module alu
//      if placed outside the module, package items are imported into
//      a pseudo-global $unit decl space (need to be careful with $unit,
//      as is has some hazards)
//
//      placing the package import here is added in SV-2009; legacy
//      code only allows either $unit or the (within) module scope
import definitions_pkg::*;
#(
    //  type params
)(
    input instruction_t iw,
    input logic         clk,

    output word_t       res
);

    always_comb begin
        unique case (iw.opcode_e)
            ADD: res = iw.a + iw.b;
            SUB: res = iw.a - iw.b;
            //  fully qualified name isn't necessary due to wildcard
            //  however, for immediate clarity might be useful
            MULT: res = definitions_pkg::multiplier(iw.a, iw.b);
            DIV2: res = iw.a >> 1;
        endcase
    end


endmodule: alu
