module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output reg match;
output reg [4:0] match_index;
output reg valid;
//...coding....
integer i;
integer j;
integer k;

reg [5:0] stringlen;
reg [7:0] stringdata[31:0];

reg [3:0] current_state,next_state;

reg [31:0] index_list;
reg [4:0] patternlen;

reg first_flag;

reg star_flag;
reg star_first;
reg [4:0] star_pos;
reg [4:0] starlen;

parameter IDLE = 4'd0;
parameter WAIT_RECIVE = 4'd1;
parameter RECIVE_STRING = 4'd2;
parameter FIRST_PATTERN = 4'd3;
parameter MATCHING = 4'd4;
parameter OUTPUT = 4'd5;

//current_state
always @(posedge clk or  posedge reset ) begin
    if (reset) current_state <= IDLE;
    else if(ispattern == 1'b0 && current_state==FIRST_PATTERN) current_state <= OUTPUT;
    else current_state <= next_state;
end

//next_state
always @(*) begin
    case (current_state)
        IDLE: next_state = (isstring == 1'b1) ? RECIVE_STRING : WAIT_RECIVE;
        WAIT_RECIVE:begin
            if(isstring == 1'b1) next_state = RECIVE_STRING;
            else if(ispattern == 1'b1) next_state = FIRST_PATTERN;
            else next_state = current_state;
        end
        RECIVE_STRING:begin
            if(isstring == 1'b0 && ispattern == 1'b0) next_state = WAIT_RECIVE;
            else if(isstring == 1'b0 && ispattern == 1'b1) next_state = FIRST_PATTERN;
            else next_state = current_state;
        end
        FIRST_PATTERN:begin
            if(ispattern == 1'b1 && star_first == 1'b1) next_state = FIRST_PATTERN;
            else if (ispattern == 1'b1 && star_first == 1'b0) next_state = MATCHING;
            else next_state = current_state;
        end
        MATCHING: next_state = (ispattern == 1'b0 ) ? OUTPUT : current_state;
        OUTPUT: next_state = (valid == 1'd0) ? WAIT_RECIVE : current_state;
        default: next_state = current_state;
    endcase
end

//stringdata
always @(posedge clk or  posedge reset) begin
    if (reset) begin
        for (i=0;i<32 ;i=i+1) stringdata[i] <= 8'h0;
    end
    else if (next_state == RECIVE_STRING && current_state == WAIT_RECIVE) stringdata[0] <= chardata;
    else if (next_state == RECIVE_STRING) stringdata[stringlen] <= chardata;
end

//stringlen
always @(posedge clk or  posedge reset) begin
    if (reset) stringlen <= 6'd0;
    else if(next_state == RECIVE_STRING && current_state == WAIT_RECIVE) stringlen <= 6'd1;
    else if (next_state == RECIVE_STRING) stringlen <= stringlen + 6'd1;
    else stringlen <= stringlen;
end

//patternlen
always @(posedge clk or posedge reset) begin
    if (reset) patternlen <= 5'd0;
    else if (next_state == FIRST_PATTERN) patternlen <= (chardata == 8'h5E || chardata == 8'h2A) ? 5'd0 : 5'd1;
    else if (next_state == MATCHING) patternlen <= (chardata == 8'h2A) ? 5'd0 : patternlen + 5'd1;
    else patternlen <= patternlen;
end

//valid
always @(posedge clk or posedge reset) begin
    if (reset) valid <= 1'b0;
    else if(ispattern==0 && current_state==OUTPUT) valid <= 1'b1;
    else valid <= 0;
end

//match
always @(posedge clk or posedge reset) begin
    if (reset) match <= 1'b0;
    else if(ispattern==0 && current_state==OUTPUT) match <= |index_list;
    else match <= 1'b0;
end
//match_index
always @(posedge clk or posedge reset) begin
    if (reset) match_index <= 5'd0;
    else if(star_flag == 1) match_index <= star_pos;
    else if(star_flag == 0) begin
        // for (k=31;k>=0;k=k-1 ) begin
        //     if(index_list[k]==1)begin
        //         match_index = k;
        //     end
        //     else match_index = match_index;
        // end
        if(index_list[0] == 1'b1) match_index <= 0;
        else if(index_list[1] == 1'b1) match_index <= 1;
        else if(index_list[2] == 1'b1) match_index <= 2;
        else if(index_list[3] == 1'b1) match_index <= 3;
        else if(index_list[4] == 1'b1) match_index <= 4;
        else if(index_list[5] == 1'b1) match_index <= 5;
        else if(index_list[6] == 1'b1) match_index <= 6;
        else if(index_list[7] == 1'b1) match_index <= 7;
        else if(index_list[8] == 1'b1) match_index <= 8;
        else if(index_list[9] == 1'b1) match_index <= 9;
        else if(index_list[10] == 1'b1) match_index <= 10;
        else if(index_list[11] == 1'b1) match_index <= 11;
        else if(index_list[12] == 1'b1) match_index <= 12;
        else if(index_list[13] == 1'b1) match_index <= 13;
        else if(index_list[14] == 1'b1) match_index <= 14;
        else if(index_list[15] == 1'b1) match_index <= 15;
        else if(index_list[16] == 1'b1) match_index <= 16;
        else if(index_list[17] == 1'b1) match_index <= 17;
        else if(index_list[18] == 1'b1) match_index <= 18;
        else if(index_list[19] == 1'b1) match_index <= 19;
        else if(index_list[20] == 1'b1) match_index <= 20;
        else if(index_list[21] == 1'b1) match_index <= 21;
        else if(index_list[22] == 1'b1) match_index <= 22;
        else if(index_list[23] == 1'b1) match_index <= 23;
        else if(index_list[24] == 1'b1) match_index <= 24;
        else if(index_list[25] == 1'b1) match_index <= 25;
        else if(index_list[26] == 1'b1) match_index <= 26;
        else if(index_list[27] == 1'b1) match_index <= 27;
        else if(index_list[28] == 1'b1) match_index <= 28;
        else if(index_list[29] == 1'b1) match_index <= 29;
        else if(index_list[30] == 1'b1) match_index <= 30;
        else if(index_list[31] == 1'b1) match_index <= 31;
    end
    else match_index <= 5'd0;
end

//first_flag
always @(posedge clk or posedge reset)begin
    if (reset) first_flag <= 1'b0;
    else if(next_state == FIRST_PATTERN && chardata == 8'h5E) first_flag <= 1'b1;
    else first_flag <= 1'b0;
end

//star_flag
always @(posedge clk or posedge reset) begin
    if(reset) star_flag <= 1'b0;
    else if(next_state == WAIT_RECIVE) star_flag <= 1'b0;
    else if(chardata == 8'h2A && (patternlen == 5'd0 || |index_list)) star_flag <= 1'b1;
    else star_flag <= star_flag;
end
//star_first
always @(posedge clk or posedge reset) begin
    if(reset) star_first <= 1'b0;
    else if(next_state == WAIT_RECIVE) star_first <= 1'b0;
    else if(chardata == 8'h2A && (patternlen == 5'd0 || |index_list)) star_first <= 1'b1;
    else star_first <= 0;
end

//starlen
always @(posedge clk or posedge reset) begin
    if(reset) starlen <= 5'd0;
    else if(chardata == 8'h2A) starlen <= patternlen;
    else starlen <= starlen;
end

//star_pos
always @(posedge clk or posedge reset) begin
    if(reset) star_pos <= 5'd0;
    else if(next_state == WAIT_RECIVE) star_pos <= 5'd0;
    else if(chardata == 8'h2A) begin
        // for (k=31; k>=0; k=k-1 ) begin
        //     if(index_list[k]==1)begin
        //         star_pos = k;
        //     end
        //     else star_pos = star_pos;
        // end
        if(index_list[0] == 1'b1) star_pos <= 0;
        else if(index_list[1] == 1'b1) star_pos <= 1;
        else if(index_list[2] == 1'b1) star_pos <= 2;
        else if(index_list[3] == 1'b1) star_pos <= 3;
        else if(index_list[4] == 1'b1) star_pos <= 4;
        else if(index_list[5] == 1'b1) star_pos <= 5;
        else if(index_list[6] == 1'b1) star_pos <= 6;
        else if(index_list[7] == 1'b1) star_pos <= 7;
        else if(index_list[8] == 1'b1) star_pos <= 8;
        else if(index_list[9] == 1'b1) star_pos <= 9;
        else if(index_list[10] == 1'b1) star_pos <= 10;
        else if(index_list[11] == 1'b1) star_pos <= 11;
        else if(index_list[12] == 1'b1) star_pos <= 12;
        else if(index_list[13] == 1'b1) star_pos <= 13;
        else if(index_list[14] == 1'b1) star_pos <= 14;
        else if(index_list[15] == 1'b1) star_pos <= 15;
        else if(index_list[16] == 1'b1) star_pos <= 16;
        else if(index_list[17] == 1'b1) star_pos <= 17;
        else if(index_list[18] == 1'b1) star_pos <= 18;
        else if(index_list[19] == 1'b1) star_pos <= 19;
        else if(index_list[20] == 1'b1) star_pos <= 20;
        else if(index_list[21] == 1'b1) star_pos <= 21;
        else if(index_list[22] == 1'b1) star_pos <= 22;
        else if(index_list[23] == 1'b1) star_pos <= 23;
        else if(index_list[24] == 1'b1) star_pos <= 24;
        else if(index_list[25] == 1'b1) star_pos <= 25;
        else if(index_list[26] == 1'b1) star_pos <= 26;
        else if(index_list[27] == 1'b1) star_pos <= 27;
        else if(index_list[28] == 1'b1) star_pos <= 28;
        else if(index_list[29] == 1'b1) star_pos <= 29;
        else if(index_list[30] == 1'b1) star_pos <= 30;
        else if(index_list[31] == 1'b1) star_pos <= 31;
    end
    else star_pos <= star_pos;
end

//index_list
always @(posedge clk or posedge reset)begin
    if (reset) index_list <= {32{1'b0}};
    else if(next_state == FIRST_PATTERN) begin
        if(chardata == 8'h5E) index_list <= index_list;
        else if(chardata == 8'h2E) index_list <= {32{1'b1}};
        else if (chardata == 8'h2A) index_list <= index_list;
        else begin
            for (j=0; j<32; j=j+1 ) begin
                if(j<stringlen)begin
                    if (chardata == stringdata[j]) 
                        index_list[j] <= 1; 
                    else 
                        index_list[j] <= 0;
                end
                else index_list[j] <= 0;
            end
        end
    end
    else if(next_state == MATCHING)begin
        for (j=0; j<32; j=j+1 ) begin
            if(chardata == 8'h24)begin
                if(index_list[j] == 1'b1)begin
                    if(stringdata[j+patternlen] == 8'h20 || (j+patternlen) == stringlen)
                        index_list[j] <= 1'b1;
                    else index_list[j] <= 1'b0;
                end
                else index_list[j] <= 1'b0;
            end
            else if (chardata == 8'h2E) begin
                if (first_flag) begin
                    if(j == 0) index_list[j] <= 1;
                    else if(stringdata[j-1] == 8'h20) index_list[j] <= 1;
                    else index_list[j] <= 0;
                end
                else if(index_list[j] == 1'b1)begin
                    if((j+patternlen)<stringlen) index_list[j] <= 1'b1;
                    else index_list[j] <= 1'b0;
                end
                else index_list[j] <= 1'b0;

            end
            else if (chardata == 8'h2A) index_list <= index_list;
            else begin
                if (first_flag) begin
                    if(j == 0 && stringdata[j] == chardata) index_list[j] <= 1;
                    else if(stringdata[j-1] == 8'h20 && stringdata[j] == chardata) index_list[j] <= 1;
                    else index_list[j] <= 0;
                end
                else if(star_flag)begin
                    if((j+patternlen)<stringlen && (star_pos+starlen-1) < j)begin
                        if(star_first)begin
                            if(chardata == stringdata[j])begin
                                index_list[j] <= 1;
                                index_list[star_pos] <= 0;
                            end
                            else index_list[j] <= 0;
                        end
                        else begin
                            if(index_list[j] == 1'b1) begin
                                if (chardata != stringdata[j+patternlen]) index_list[j] <= 0;
                                else index_list[j] <= 1;
                            end
                            else index_list[j] <= 0;
                        end
                    end
                    else index_list[j] <= 0;
                end
                else if(index_list[j] == 1'b1 && (j+patternlen)<stringlen)begin
                    if (chardata == stringdata[j+patternlen]) index_list[j] <= 1;
                    else index_list[j] <= 0;
                end
                else index_list[j] <= 0;
            end
        end
    end
    else index_list <= index_list;
end
endmodule