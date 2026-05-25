onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipelined_tb/clk
add wave -noupdate /pipelined_tb/reset
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/instruction
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/Db
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/ZeroFlag
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/NegativeFlag
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/Reg2Loc
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/ALUSrc
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/Mem2Reg
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/RegWrite
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/MemWrite
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/MemRead
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/BrTaken
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/UncondBr
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/SetFlags
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/IsBL
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/IsBR
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/isDType
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/ALUOp
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/extended_op
add wave -noupdate -group CNTRLS /pipelined_tb/DUT/control/branch_conditional
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/clk
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/reset
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/BrLoc
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/Db
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/BrTaken
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/IsBR
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/instruction_output
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/PCp4
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/CurrPC
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/NextPC
add wave -noupdate -group IF /pipelined_tb/DUT/instructionFetch/BrMux_noBR
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/clk
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/reset
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/instruction
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/currPC
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/PCp4
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/instructionOut
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/currPCOut
add wave -noupdate -group IF_ID /pipelined_tb/DUT/firstpipeline/PCp4Out
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/clk
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/reset
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Reg2Loc
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/ALUSrc
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/RegWrite
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/IsBL
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/isDType
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/UncondBr
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/WriteBck
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/PCp4
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/CurrPC
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/instruction
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/WBRd
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/WBErrorA
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/WBErrorB
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Da
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Db
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/ALUInput
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/BrLoc
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Rd
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Rm
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Rn
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Da_pre_wb_mux
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Db_pre_wb_mux
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/splitout
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Aw_in
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Dw_in
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Immediate
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/DT_address
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/Immediate64
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/DT_address64
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/shift
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/CondAddr19
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/BrAddr26
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/BrAddr64
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/CondAddr64
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/BrLoc_unshifted
add wave -noupdate -group ID /pipelined_tb/DUT/instructionDecode/BrLoc_unsummed
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/clk
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/reset
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/readData1
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/readData2
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/ALUInput
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/Rd
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/Rn
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/Rm
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/ALUOp
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/ALUSrc
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/MemtoReg
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/RegWrite
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/MemRead
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/MemWrite
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/BrTaken
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/UncondBr
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/IsBL
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/readData1Out
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/readData2Out
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/ALUInputOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/RdOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/RnOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/RmOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/ALUOpOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/ALUSrcOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/MemtoRegOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/RegWriteOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/MemReadOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/MemWriteOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/BrTakenOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/UncondBrOut
add wave -noupdate -group ID_EX /pipelined_tb/DUT/secondpipeline/IsBLOut
add wave -noupdate -group EX /pipelined_tb/DUT/execution/UncondBr
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ALUOp
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ALUIn0
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ALUIn1
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ALUIn_WB
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ALUIn_EXMEM
add wave -noupdate -group EX /pipelined_tb/DUT/execution/FwdA
add wave -noupdate -group EX /pipelined_tb/DUT/execution/FwdB
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ALURes
add wave -noupdate -group EX /pipelined_tb/DUT/execution/ZeroFlag
add wave -noupdate -group EX /pipelined_tb/DUT/execution/NegativeFlag
add wave -noupdate -group EX /pipelined_tb/DUT/execution/A
add wave -noupdate -group EX /pipelined_tb/DUT/execution/B
add wave -noupdate -group EX /pipelined_tb/DUT/execution/firstlevel1A
add wave -noupdate -group EX /pipelined_tb/DUT/execution/firstlevel2A
add wave -noupdate -group EX /pipelined_tb/DUT/execution/firstlevel1B
add wave -noupdate -group EX /pipelined_tb/DUT/execution/firstlevel2B
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/clk
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/reset
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/ALURes
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/ReadData2
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/Rd
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/MemtoReg
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/RegWrite
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/MemRead
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/MemWrite
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/IsBL
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/address
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/writeMemData
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/RdOut
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/MemtoRegOut
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/RegWriteOut
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/MemReadOut
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/MemWriteOut
add wave -noupdate -group EX_MEM /pipelined_tb/DUT/thirdpipeline/IsBLOut
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/address
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/write_enable
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/read_enable
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/write_data
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/clk
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/read_data
add wave -noupdate -group MEM /pipelined_tb/DUT/MEM/aligned_address
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/clk
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/reset
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/readMemData
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/ALURes
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/Rd
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/MemtoReg
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/RegWrite
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/IsBL
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/ALUResOut
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/readMemDataOut
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/RdOut
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/MemtoRegOut
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/RegWriteOut
add wave -noupdate -group MEM_WB /pipelined_tb/DUT/fourthpipeline/IsBLOut
add wave -noupdate -group WB /pipelined_tb/DUT/writeBack/ALURes
add wave -noupdate -group WB /pipelined_tb/DUT/writeBack/MEMData
add wave -noupdate -group WB /pipelined_tb/DUT/writeBack/Mem2Reg
add wave -noupdate -group WB /pipelined_tb/DUT/writeBack/WriteBck
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RnID
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RmID
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RnIDEX
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RmIDEX
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RdEXMEM
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RdMEMWB
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RegWriteEXMEM
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/RegWriteMEMWB
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/ALUSrcEX
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/Reg2LocID
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/ForwardA
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/ForwardB
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/WBErrorA
add wave -noupdate -group {FWDING UNIT} /pipelined_tb/DUT/fwding_unit/WBErrorB
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[0]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[1]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[2]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[3]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[4]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[5]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[29]}
add wave -noupdate -expand -group REGISTERS -radix unsigned {/pipelined_tb/DUT/instructionDecode/registerFile/reg_outs[30]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1805593 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 82
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {5302500 ps}
