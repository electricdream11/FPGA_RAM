module ram(
	input clk,
	input rst_n,
	
	input im_write_en,
	input im_read_en,

	input im_bite_clk,
	input [2:0] im_addr,
	input [2:0] im_data,
	output reg [7:0] om_data
);
	reg [7:0] data_rom [2:0];
	reg bite_clk_temp1;
	reg bite_clk_temp2;
	wire bite_clk_en;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		bite_clk_temp1<=1'b0;
	end
	else begin
		bite_clk_temp1<=im_bite_clk;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		bite_clk_temp2<=1'b0;
	end
	else begin
		bite_clk_temp2<=bite_clk_temp1;
	end
end
assign bite_clk_en = (bite_clk_temp1==1'b1 && bite_clk_temp2==1'b0);
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_data<=8'b0;	
	end	
	else if(im_write_en && bite_clk_en)begin
		data_rom[im_addr]<=  im_data;
	end
	else if(im_read_en && bite_clk_en)begin
		om_data<=data_rom[im_addr];
	end
end
endmodule
