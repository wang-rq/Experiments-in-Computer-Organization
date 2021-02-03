	.data    # 定义数据段，数据将存放于此
sentence1:   # 定义变量名，实际是一个地址
	.asciiz "Please enter the integers with zero to finish:\n"
endl:
	.asciiz "\n"           # 伪指令
str:                       # 存输入的字符串
	.space 60
string:
	.space 4               # 存输出的字符串
	.set noreorder         # 编译用伪指令，不关心

	.text                  # 代码段，可执行的代码存放于此
.global main               # 指出main为全局作用域符号
main:
	li $v0, 4004           # 调用号4004（write）放入$v0
	li $a0, 1              # 目标1号文件（标准输出）放入$a0
	la $a1, sentence1      # 待输出的字符串首地址放入$a1
	li $a2, 47             # 要输出字节数为47，放入$a2
	syscall                # 准备就绪，交付内核完成调用
	li $t0, 48             # '0'
	li $t1, 49             # '1'
	li $t2, 50             # '2'
	li $t3, 0              # 存放answer
	li $t4, 0              # $t4存放连续的2的个数

	li $v0, 4003           # 调用号4003（read）放入$v0
	li $a0, 0			   # 目标0号文件（标准输入）放入$a0
	la $a1, str            # $a1存放输入字符串str的首地址
	li $a2, 60             # 读取60个字节
	syscall                # 准备就绪，交付内核完成调用
	la $t5, str            # $t5存放输入字符串str的首地址
loop:
	lb $t6, 0($t5)         # 将一个字节从内存取到寄存器$t6中
	beq $t6, $t0, print    # 如果是0，直接输出结果
	nop                    # important to make program happy
	beq $t6, $t1, addone   # 如果是1，跳转至addone
	nop
	beq $t6, $t2, addtwo   # 如果是2，跳转至addtwo
	nop
addone:
	addi $t3, $t3, 1       # $t3++
	li $t4, 0              # $t4清零
	addi $t5, $t5, 2       # $t5=$t5+2(跳过空格找下一个数)
	j loop                 # 无条件跳转
	nop
addtwo:
	addi $t4, $t4, 1       # $t4++
	add $t7, $t4, $t4      # $t7=2*$t4
	add $t3, $t3, $t7      # $t3=$t7+$t3
	addi $t5, $t5, 2       # 待读取的地址加两字节，跳过空格
	j loop  
	nop
print:
	addi $a0, $t3, 0       # 传参
	jal printfunc          # 过程调用，jump and link
	nop

	li $v0, 4001           # 调用号4001(exit)放入$v0
	syscall                # 准备就绪，交付内核完成调用


.global printfunc
printfunc:
	addi $t0, $a0, 0       # $t0=$a0
	li $t2, 2              # 需要的空间-1
	li $t5, 2              # 最后用来计算输出字符个数
	la $t3, string         # 最后一个字符的地址是$t3+$t2中
loop2:
	rem $t1, $t0, 10       # $t1存余数
	div $t0, $t0, 10       # $t0=$t0/10
	addi $t1, $t1, 48      # 转化为字符
	add $t4, $t3, $t2      # 存储地址
	sb $t1, 0($t4)         # 存字节
	addi $t2, $t2, -1      # 向前挪一个字节
	beq $t0, $zero, printstring   # 如果是0，跳出循环
	nop
	j loop2                # 如果不为0，继续循环
	nop
printstring:
	sub $a2, $t5, $t2         # 要输出这么多字符
	addi $t2, $t2, 1          # 开始的数的顺序
	li $v0, 4004              
	add $a1, $t3, $t2         # 开始地址
	li $a0, 1                 # 标准输出
	syscall
endline:                      # 换行
	li $v0, 4004              
	li $a0, 1
	la $a1, endl
	li $a2, 1                 
	syscall

	jr $ra                    # 跳回寄存器中的地址
	nop
