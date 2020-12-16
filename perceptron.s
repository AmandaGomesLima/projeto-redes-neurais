# Perceptron
# ------------------------------------------------------------------------
# Declaracao de dados
.data
TAM_WORD = 4 						# 4 bytes por word
QTD_RODADA = 30						# Quantidade de rodadas				
QTD_TREINO = 5						# Quantidade de elementos no treino
QTD_TESTE = 60						# Quantidade de testes impressos
fPeso1: .float 0.0					# Peso 1
fPeso2: .float 0.8					# Peso 2
taxaAprendizado: .float 0.05		# Taxa de aprendizado
erroConsiderado: .float 0.001		# Margem de erro considerado para o somatorio
matrizTreino: .word 2, 2, 4			# Matriz com elementos para treino
		      .word 3, 3, 6
		      .word 4, 4, 8
		      .word 5, 5, 10
		      .word 6, 6, 12
txtPeso1: .asciiz "peso1: "
txtPeso2: .asciiz "peso2: "              
txtSoma: .asciiz " + "
txtIgual: .asciiz " = "
txtQuebraLinha: .asciiz "\n"
# ------------------------------------------------------------------------
# Secao de codigo
.text
.globl main
.ent main
main:
	la $s0, matrizTreino 			# s0 = end. base do treino[][]
	l.s $f0, fPeso1					# f0 = peso[0]
	l.s $f1, fPeso2					# f1 = peso[1]
	l.s $f2, taxaAprendizado        # f2 = taxaAprendizado
	l.s $f7, erroConsiderado		# f7 = erroConsiderado
	li $t0, QTD_RODADA				# Carregar qtdTreino
	li $t1, 0 						# k = 0
	li $t2, 1						# z = 1
rodadaLoop:
	jal treino
	beq $v0, $t2, endRodadaLoop		# v0 == z, vai para endRodadaLoop
	add $t1, $t1, 1 				# k = k + 1
	blt $t1, $t0, rodadaLoop   		# k < QTD_RODADA
endRodadaLoop:
	jal imprime
	# Finalizar o programa
	li $v0, 10 						# Determinar codigo da funcao terminar
	syscall 						# Chamar sistema para executar funcao
.end main

# -----------------------------------------------------
# Função para treinar os pesos
# -----
# Retorno
# $v0 - 1 se correto (pesos adequados) e 
#       0 se nao chegou nos pesos adequados
.globl treino
.ent treino
treino:
	li $t3, 0 						# i = 0
	li $t4, QTD_TREINO				# QTD_TREINO
	li $v0, 0                       # correto = 0 (false)

treinoLoop:
	mul $t5, $t3, 3					# (i * numCols)
	mul $t5, $t5, TAM_WORD			# ((i * numCols) * tamWord)
	add $t5, $s0, $t5 				# indice = enderecoBase + ((i * numCols) * tamWord)
	# calculo do termo1
	lw $t6, ($t5)					# num1 = treino[i][0]
	mtc1 $t6, $f3 					
	cvt.s.w $f3, $f3				# num1 = (float) num1
	mul.s $f5, $f3, $f0				# termo1 = num1 * peso[0]
	# calculo do termo 2
	add $t5, $t5, TAM_WORD 			# indice = indice + tamWord
	lw $t6, ($t5) 					# num2 = treino[i][1]
	mtc1 $t6, $f4
	cvt.s.w $f4, $f4				# num2 = (float) num2
	mul.s $f6, $f4, $f1				# termo2 = num2 * peso[1]
	# soma dos termos
	add.s $f5, $f5, $f6				# soma = termo1 + termo2
	# obtem saida esperada
	add $t5, $t5, TAM_WORD 			# indice = indice + tamWord
	lw $t6, ($t5) 					
	mtc1 $t6, $f6
	cvt.s.w $f6, $f6				# saida = treino[i][2]
	sub.s $f5, $f6, $f5				# erro = saida - soma
	abs.s $f8, $f5					# f8 = |erro|
	# verifica se soma esta correta
	c.le.s $f8, $f7					# se |erro| < erroConsiderado, code = 1
	bc1f endIf						# se code == 0, vai para endIf
	li $v0, 1						# correto = 1
	j endTreinoLoop					# vai para endTreinoLoop
endIf:
	mul.s $f5, $f5, $f2				# (erro * taxaAprendzado)
	# atualiza peso[0]
	mul.s $f6, $f5, $f3				# ((erro * taxaAprendzado) * num1)
	add.s $f0, $f0, $f6				# peso[0] += ((erro * taxaAprendzado) * num1)
	# atualiza peso[1]
	mul.s $f6, $f5, $f4				# ((erro * taxaAprendzado) * num2)
	add.s $f1, $f1, $f6				# peso[1] += ((erro * taxaAprendzado) * num2)
	# --
	add $t3, $t3, 1 				# i = i + 1
	blt $t3, $t4, treinoLoop  		# i < QTD_TREINO, vai para treinoLoop
endTreinoLoop:
	s.s $f0, fPeso1
	s.s $f1, fPeso2
	# retornar para a funcao que o chamou
	jr $ra
.end treino

# -----------------------------------------------------
# Função apra treinar os pesos
# -----
# Retorno
# $v0 - 1 se correto (pesos adequados) e 
#       0 se nao chegou nos pesos adequados
.globl imprime
.ent imprime
imprime:
	li $t3, 0 						# i = 0
	li $t4, QTD_TESTE				# QTD_TESTE

    li $v0, 4
	la $a0, txtPeso1
	syscall                         # imprime "peso1 "
    li $v0, 2
	mov.s $f12, $f0
	syscall                         # imprime valor do peso1
    li $v0, 4
	la $a0, txtQuebraLinha
	syscall                         # faz quebra de linha no console
    li $v0, 4
	la $a0, txtPeso2
	syscall                         # imprime "peso2 "
    li $v0, 2
	mov.s $f12, $f1
	syscall                         # imprime valor do peso2
    li $v0, 4
	la $a0, txtQuebraLinha
	syscall                         # faz quebra de linha no console
    li $v0, 4
	la $a0, txtQuebraLinha
	syscall                         # faz quebra de linha no console

imprimeLoop:
	addi $t5, $t3, 1				# num = i + 1
	# calculo do termo 1
	mtc1 $t5, $f3					
	cvt.s.w $f3, $f3				# num = (float) num
	mul.s $f4, $f3, $f0				# termo1 = num * peso[0]
	# calculo do termo 2
	mul.s $f5, $f3, $f1				# termo2 = num * peso[1]
	# soma dos termos
	add.s $f6, $f5, $f4				# soma = termo1 + termo2
	li $v0, 1                       
	move $a0, $t5
	syscall                         # imprime valor do num (inteiro)
	li $v0, 4
	la $a0, txtSoma
	syscall                         # imprime "+"
	li $v0, 1
	move $a0, $t5
	syscall                         # imprime valor do num (inteiro)
	li $v0, 4
	la $a0, txtIgual
	syscall                         # imprime "="
	li $v0, 2
	mov.s $f12, $f6
	syscall                         # imprime valor da soma (float)
	li $v0, 4
	la $a0, txtQuebraLinha
	syscall                         # faz quebra de linha no console
	# --
	add $t3, $t3, 1 				# i = i + 1
	blt $t3, $t4, imprimeLoop  		# i < QTD_TESTE, vai para imprimeLoop
	# retorna para a funcao que o chamou
	jr $ra
.end treino
