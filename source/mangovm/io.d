module mangovm.io;

import std.container.array : Array;
import std.system : Endian;

/// Represents a buffer of bytes. This implementation does not use the GC.
class ByteBuffer {
    protected Array!byte bytes;
    protected size_t _position;
    protected Endian _endianness;

    @property size_t position() @safe nothrow pure { return this._position; }
    @property void position(size_t position) @safe nothrow {
        this._position = position;
    }

    @property Endian endianness() @safe nothrow pure { return this._endianness;}
    @property void endianness(Endian endian) @safe nothrow { 
        this._endianness = endianness; 
    }

    private this(Array!byte bytes, Endian endianness) @trusted nothrow {
        this.bytes = bytes;
        this._endianness = endianness;
    }

    static ByteBuffer alloc(in size_t size, Endian endianness = Endian.littleEndian) @system {
        Array!byte array = Array!byte();
        array.reserve(size);

        return new ByteBuffer(array, endianness);
    }

    static ByteBuffer load(in byte[] buffer, Endian endianness = Endian.littleEndian) @system {
        Array!byte array = Array!byte(buffer);

        return new ByteBuffer(array, endianness);
    }

    byte getByte() @system nothrow {
        return this.bytes[this._position++];
    }

    ubyte getUByte() @system nothrow {
        return getByte();
    }

    @property size_t size() @safe nothrow pure { return this.bytes.length; }

    void destroy() @system nothrow {
        this.bytes.clear();
    }
}