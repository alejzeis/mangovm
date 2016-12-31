module mangovm.exception;

class InvalidBytecodeException : Exception {
    this(in string message) {
        super(message);
    }
}