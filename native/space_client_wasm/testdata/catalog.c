// Синтетический гость CI. Не SDK и не парсер произвольных пользовательских файлов.
static char input[16384], output[16384];
static int length(const char *s) { int n=0; while(s[n]) n++; return n; }
static char *find(char *s, const char *needle) {
  for (; *s; s++) { int i=0; while(needle[i] && s[i]==needle[i]) i++; if(!needle[i]) return s+i; }
  __builtin_trap();
}
static int append(int n, const char *s) { while(*s) output[n++]=*s++; return n; }
static unsigned long long result(int n) {
  return ((unsigned long long)(unsigned int)output << 32) | (unsigned int)n;
}
unsigned int space_alloc(unsigned int n) { if(n>=sizeof(input)) __builtin_trap(); return (unsigned int)input; }
void space_free(unsigned int p, unsigned int n) { (void)p; (void)n; }
unsigned long long space_handle(unsigned int p, unsigned int n) {
#ifdef SPIN
  for (;;) {}
#endif
#ifdef TRAP
  __builtin_trap();
#endif
  if(p!=(unsigned int)input || n>=sizeof(input)) __builtin_trap();
  input[n]=0;
  if(input[10]=='s') {
    return result(append(0,"{\"op\":\"list\",\"limit\":1,\"cursor\":null,\"state\":null}"));
  }
  const char *field = input[10]=='l' ? "\"handle\":\"" : "\"bytes\":\"";
  char *value=find(input,field);
  int end=0; while(value[end] && value[end]!='"' && end<256) end++;
  if(end==256 || !value[end]) __builtin_trap();
  int out=append(0,input[10]=='l' ? "{\"op\":\"read\",\"handle\":\"" : "{\"op\":\"done\",\"value\":\"");
  for(int i=0;i<end;i++) output[out++]=value[i];
  out=append(out,input[10]=='l' ? "\",\"offset\":0,\"limit\":64,\"state\":null}" : "\"}");
  return result(out);
}
