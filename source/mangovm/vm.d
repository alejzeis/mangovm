module mangovm.vm;

import std.file : exists, isFile, read;
import std.string : endsWith;
import std.exception : enforce;

import mangovm.exception;

immutable ubyte[] BYTECODE_HEADER = [0x5E, 0xEE, 0xFA, 0xAE];

void validateBytecode(in string bytecodeFile) @trusted 
in {
    assert(exists(bytecodeFile), "bytecode file must exist!");
    assert(isFile(bytecodeFile), "bytecode file must be a file!");

    assert(bytecodeFile.endsWith(".mc"), "bytecode file must be a mango bytecode (.mc) file!");
} body {
    ubyte[] header = cast(ubyte[]) read(bytecodeFile, 6);
    enforce(header[0..3] == BYTECODE_HEADER, new InvalidBytecodeException("Bytecode header does not match!"));
}

/// Represents a Virtual Machine which executes bytecode from a file.
class VM {
    immutable string mainFile;

    /++
        Create a new VM instance for executing a file 
        in the virtual machine. To begin execution call the
        "execute()" method.

        Params:
                mainFile =  The file to be executed in the VM.
    +/
    this(in string mainFile) @safe 
    in {
        assert(exists(mainFile), "mainFile must exist!");
        assert(isFile(mainFile), "mainFile must be a file!");

        assert(mainFile.endsWith(".mc"), "mainFile must be a mango bytecode (.mc) file!");
    } body {
        this.mainFile = mainFile;

        validateBytecode(mainFile);
    }
}