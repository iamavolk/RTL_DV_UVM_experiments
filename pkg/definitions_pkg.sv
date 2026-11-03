package definitions_pkg;
    localparam VERSION = "1.1";

    `ifdef _64bit
        typedef logic [63:0] word_t;
    `elsif _32bit
        typedef logic [31:0] word_t;
    `else
        typedef logic [15:0] word_t;
    `endif

    typedef enum logic [1:0] {ADD, SUB, MULT, DIV2} opcodes_t ;
    typedef enum logic [3:0] {COUNT[0:15]} states_enum_t;

    typedef struct {
        word_t      a, b;
        opcodes_t   opcode_e;
    } instruction_t;

    function automatic word_t multiplier (input word_t a, b);
        //  mul
    endfunction

endpackage: definitions_pkg
