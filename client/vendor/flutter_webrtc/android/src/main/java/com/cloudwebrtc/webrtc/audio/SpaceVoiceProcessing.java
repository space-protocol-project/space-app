package com.cloudwebrtc.webrtc.audio;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.HashMap;
import java.util.Map;

/** Усиление и закрытый по умолчанию шлюз после обработки WebRTC, до Opus. */
public final class SpaceVoiceProcessing implements AudioProcessingAdapter.ExternalAudioFrameProcessing {
    private volatile float gain = 1;
    private volatile boolean transmitting;
    private volatile boolean interrupted;
    private volatile double rms;
    private volatile long sampledAt;
    private int channels = 1;
    private int rate = 48000;
    private long denoiser;
    private volatile boolean failed;
    private long processingFrames, processingNanos, maximumNanos;

    public synchronized Map<String, Object> statistics() {
        Map<String, Object> result = new HashMap<>();
        result.put("frames", processingFrames);
        result.put("processingMicros", processingNanos / 1000);
        result.put("maximumMicros", maximumNanos / 1000);
        return result;
    }

    private static native int processDenoiser(long context, ByteBuffer buffer, int frames, int rate);

    public synchronized boolean denoiser(long context, long expected) {
        if (denoiser != expected) return false;
        if (context != 0) System.loadLibrary("space_voice");
        denoiser = context;
        failed = false;
        processingFrames = 0; processingNanos = 0; maximumNanos = 0;
        return true;
    }

    public boolean failed() { return failed; }

    public void gain(double value) {
        if (!Double.isFinite(value) || value < 0 || value > 2) {
            throw new IllegalArgumentException("Invalid microphone gain");
        }
        gain = (float) value;
    }

    public void transmit(boolean enabled) { transmitting = enabled; }
    public void capture(boolean enabled) {
        transmitting = false;
        rms = 0;
        if (enabled) interrupted = false;
    }
    public void interrupt() { interrupted = true; transmitting = false; }
    public boolean interrupted() { return interrupted; }
    public double level() {
        return System.nanoTime() - sampledAt < 500_000_000L ? rms : 0;
    }

    @Override public void initialize(int rate, int count) { this.rate = rate; channels = count; rms = 0; }
    @Override public void reset(int rate) { this.rate = rate; rms = 0; }

    @Override public synchronized void process(int bands, int frames, ByteBuffer buffer) {
        // webrtc-sdk m150 передаёт channels()[0], FloatS16, один блок 10 мс.
        buffer.order(ByteOrder.nativeOrder());
        if (channels != 1 || frames <= 0 || frames * 4 > buffer.capacity()) {
            for (int i = 0; i < buffer.capacity(); i++) buffer.put(i, (byte) 0);
            interrupt();
            return;
        }
        boolean valid = true;
        if (denoiser != 0) {
            long started = System.nanoTime();
            if (processDenoiser(denoiser, buffer, frames, rate) != 1) failed = true;
            long elapsed = System.nanoTime() - started;
            processingFrames++; processingNanos += elapsed;
            maximumNanos = Math.max(maximumNanos, elapsed);
        }
        double energy = 0;
        float amplification = gain;
        for (int i = 0; i < frames; i++) {
            float value = buffer.getFloat(i * 4) * amplification;
            if (!Float.isFinite(value)) { valid = false; value = 0; }
            value = Math.max(-32768, Math.min(32767, value));
            energy += (double) value * value;
            buffer.putFloat(i * 4, value);
        }
        if (!valid) interrupt();
        rms = valid ? Math.sqrt(energy / frames) / 32768 : 0;
        sampledAt = System.nanoTime();
        if (!transmitting || interrupted || failed) {
            for (int i = 0; i < frames; i++) buffer.putFloat(i * 4, 0);
        }
    }
}
