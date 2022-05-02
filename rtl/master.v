module master(
           clk,
           rst_n,
           ready,
           valid,
           data_in,
           data_out,

		   wr_en,
		   full
       );
parameter num = 8;
input clk;
input rst_n;
input ready;
input [num - 1: 0] data_in;
output reg valid;
output reg [num - 1: 0] data_out;

input wr_en;
reg rd_en;
output full;
wire empty;

wire [num - 1: 0] data_out_fifo;

//always@( posedge rd_en )
//	begin
//		data_out <= data_out_fifo;
//	end

reg	ready_r;
// reg [num - 1: 0] data;
// assign	ready_rise = (~ready_r) & ready;
always@(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			ready_r <= 1'b0;
		else
			ready_r <= ready;
	end
always@(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				data_out <= 0;
				valid	<= 1'b0;
				// ready_r	<= 1'b0;
			end
		else if (!ready)
			begin
			    rd_en<=1'b0;
				data_out <= data_out;
				valid <= 1'b1;
			end
         else
			begin
				rd_en<=1'b1;
				data_out <= data_out_fifo;
				valid <= (ready_r == 1'b1) ? 1'b1 : 1'b0; 
			end
		
	end

fifo#(
    .depth    ( 60 ),
    .width    ( 8 )
)u_fifo(
    .clk      ( clk      ),
    .rst_n    ( rst_n    ),
    .wr_en    ( wr_en    ),
    .data_in  ( data_in  ),
    .rd_en    ( rd_en    ),
    .data_out ( data_out_fifo ),
    .full     ( full     ),
    .empty    ( empty    )
);

endmodule
