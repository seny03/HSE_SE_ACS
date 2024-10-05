.data
 enter_promt: .asciz "Введите количество элементов в массиве (не больше 10): "
 error_promt: .asciz "Введенное значение некорректно, попробуйте еще раз.\n"
 overflow_promt: .asciz "Обнаружено переполнение! Последнее значение суммы до переполнения: "
 overflow_count_promt: .asciz "Количество чисел, просуммированных до переполнения: "
 sum_promt: .asciz "Значение суммы: "
 even_promt: .asciz "Количество четных чисел в массиве: "
 odd_promt: .asciz "Количество нечетных чисел в массиве: "
 ln: .asciz "\n"
 .align 2
 n: .word 0
 array: .space 40
 arrend:
 
.text 
 # Считывание количества элементов
 enter:
  li a7, 4
  la a0, enter_promt
  ecall
 
  li a7, 5
  ecall
  mv t3, a0
  
  # Проверка введенного значения на корректность
  ble t3, zero, error
  li t4, 10
  bgt t3, t4, error
  
  la t4, n
  sw t3, (t4)
  li t1, 0
  la t0, array
 
 # Заполняем массив
 fill:
  ecall
  sw a0, (t0)
  addi t0, t0, 4
  addi t1, t1, 1  
  bltu t1, t3, fill
  
 sum_mount:
  la t0, array
  li t1, 0
  li s0, 0
 
 # Суммируем элементы до переполнения 
 sum:
  lw t2, (t0)
  # Добавляем текущее число и сохраняем во временную сумму
  add t4, s0, t2
  addi t0, t0, 4
  addi t1, t1, 1
  
  # Проверяем, одного ли знака текущее число и сумма предыдущих чисел
  j check_if_sum_and_number_same_sign
 
 # Проверяем, обработали ли мы все элементы массива
 if_end_sum:
  mv s0, t4
  bltu t1, t3, sum
  
  # Если все элементы обработанны, выводим результат
  li a7, 4
  la a0, sum_promt
  ecall
  li a7, 1
  mv a0, s0
  ecall
  li a7, 4
  la a0, ln
  ecall
 
 counter_mount:
  la t0, array
  li t1, 0
  li s0, 0
  li s1, 0
 
 # Подсчет количества четных и нечетных чисел в массиве
 counter:
  lw t2, (t0)
  addi t0, t0, 4
  addi t1, t1, 1
  
  li t4, 2
  rem t4, t2, t4
  beqz t4, even
  
  addi s1, s1, 1
  
 if_end_counter:
  bltu t1, t3, counter
  
  # Если все числа обработаны, выводим результат
  li a7, 4
  la a0, even_promt
  ecall
  li a7, 1
  mv a0, s0
  ecall
  li a7, 4
  la a0, ln
  ecall
  
  li a7, 4
  la a0, odd_promt
  ecall
  li a7, 1
  mv a0, s1
  ecall
  li a7, 4
  la a0, ln
  ecall
 
 # Завершаем программу с кодом выхода 0
 end: 
  li a7, 10
  ecall
 
 even:
  addi s0, s0, 1
  j if_end_counter
 
 check_if_sum_and_number_same_sign:
  srai t5, s0, 31
  srai t6, t2, 31
  # Если одного знака, продолжаем проверку, иначе возвращаемся к суммированию, если это необходимо
  bne t5, t6, if_end_sum
 
 # Проверка, одного ли знака предыдущее и новое значение суммы
 check_if_sum_and_prev_sum_same_sign:
  srai t6, t4, 31
  beq t5, t6, if_end_sum
  
  # Если  не одного
  li a7, 4
  la a0, overflow_promt
  ecall
  li a7, 1
  mv a0, s0
  ecall
  li a7, 4
  la a0, ln
  ecall
  la a0, overflow_count_promt
  ecall
  li a7, 1
  addi a0, t1, -1 
  ecall
  li a7, 4
  la a0, ln
  ecall
  
  j counter_mount
 
 # В случае некорректного количества элементов, выводим сообщение об ошибке и просим ввести значение заново.
 error:
  li a7, 4
  la a0, error_promt
  ecall
  j enter
