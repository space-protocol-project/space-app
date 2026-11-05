file(SHA256 "${BINARY}" DIGEST)
file(WRITE "${BINARY}.sha256" "${DIGEST}\n")
