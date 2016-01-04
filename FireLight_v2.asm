;*****************************************************
;Company :
;File Name : FireLight.asm
;Author :
;Create Data : 2015-12-16
;Last Modified : 2015-12-16
;Description :
;Version : 2.0
;*****************************************************

LIST P=69P48
ROMSIZE=4096

;*****************************************************
;系统寄存器 ($000 ~ $02F, $380 ~ $38C)
;*****************************************************
IE		EQU	00H		;中断使能/禁能控制
IRQ		EQU	01H		;中断请求标志

TM0		EQU	02H		;Timer0 模式寄存器
TM1		EQU	03H		;Timer1 模式寄存器

TL0		EQU	04H		;Timer0 重载值低4位
TH0		EQU	05H		;Timer0 重载值高4位

TL1		EQU	06H		;Timer1 重载值低4位
TH1		EQU	07H		;Timer1 重载值高4位

PORTA		EQU	08H		;PortA 数据寄存器
PORTB		EQU	09H		;PortB 数据寄存器
PORTC		EQU	0AH		;PortC 数据寄存器
PORTD		EQU	0BH		;PortD 数据寄存器
PORTE		EQU	0CH		;PortE 数据寄存器

					;0DH Reserved
				
TBR		EQU	0EH		;查表寄存器
INX		EQU	0FH		;间接寻址伪索引寄存器
DPL		EQU	10H		;INX数据指针低4位
DPM		EQU	11H		;INX数据指针中4位
DPH		EQU	12H		;INX数据指针高4位

TCTL1		EQU	13H		;Timer1 控制寄存器

ADCCTL		EQU	14H		;ADC 使能与参考电压
ADCCFG		EQU	15H		;ADC configuration
ADCPORT		EQU	16H		;ADC PORT CONFIGURATION
ADCCHN		EQU	17H		;ADC channel selection

PACR		EQU	18H		;PortA 控制寄存器
PBCR		EQU	19H		;PortB 控制寄存器
PCCR		EQU	1AH		;PortC 控制寄存器
PDCR		EQU	1BH		;PortD 控制寄存器
PECR		EQU	1CH		;PortE 控制寄存器

					;1DH Reserved

WDT		EQU	1EH		;Whichdog timer control


PWMC0		EQU	20H		;PWM0 控制寄存器
PWMC1		EQU	21H		;PWM1 控制寄存器

PWMP00		EQU	22H		;PWM0 周期控制寄存器低4位
PWMP01		EQU	23H		;PWM0 周期控制寄存器高4位

PWMD00		EQU	24H		;PWM0 占空比控制寄存器低2位
PWMD01		EQU	25H		;PWM0 占空比控制寄存器中4位
PWMD02		EQU	26H		;PWM0 占空比控制寄存器高4位

PWMP10		EQU	27H		;PWM1 周期控制寄存器低4位
PWMP11		EQU	28H		;PWM1 周期控制寄存器高4位

PWMD10		EQU	29H		;PWM1 占空比控制寄存器低2位
PWMD11		EQU	2AH		;PWM1 占空比控制寄存器中4位
PWMD12		EQU	2BH		;PWM1 占空比控制寄存器高4位

					;2CH Reserved

AD_RET0		EQU	2DH		;ADC 转换结果低2位
AD_RET1		EQU	2EH		;ADC 转换结果中4位
AD_RET2		EQU	2FH		;ADC 转换结果高4位


PPACR 		EQU 	388H		;PORTA 口上拉电阻控制寄存器 
PPBCR 		EQU 	389H		;PORTB 口上拉电阻控制寄存器 
PPCCR 		EQU 	38AH		;PORTC 口上拉电阻控制寄存器 
PPDCR 		EQU 	38BH		;PORTD 口上拉电阻控制寄存器 
PPECR 		EQU 	38CH		;PORTE 口上拉电阻控制寄存器 


;*****************************************************
;用户自定义寄存器 ($030 ~ $0EF)
;*****************************************************
;Bank0
;------------------------------------------------------------------
AC_BAK 		EQU 	30H 		;AC 值备份寄存器

SYSTEM_STATE	EQU	31H		;bit 0:  0 - 主电状态(主电源正常),  1 - 应急状态(主电源停电)

SELF_STATE	EQU	32H		;bit 0:  0 - 主电状态(主电源正常),  1 - 模拟应急状态(模拟主电源停电)
					;bit 1:  0 - 非月检状态,	         1 - 月检状态
					;bit 2:  0 - 非年检状态,	         1 - 年检状态
					;bit 3:  0 - 自动模式	         1 - 手动模式
					;注释:自动模式是指，bit 0 - bit 2 均为时间流逝或是停电导致系统进入的相应状态
					;手动模式是指，bit 0 - bit 2 均为通过持续不同时长的按键而导致系统进入的相应状态

ALREADY_ENTER	EQU	33H		;bit 0:  0 - 当前并未开始充电,      1 - 当前已经开始充电
					;bit 1:  0 - 当前并未开始放电(应急),1 - 当前已经开始放电(应急)
					;bit 2:  0 - 当前并未进入手动月检,  1 - 当前已经进入手动月检状态
					;bit 3:  0 - 当前并未进入手动年检,  1 - 当前已经进入手动年检状态
				
; 用于TIMER 定时
F_1S		EQU	35H		;bit0 = 1, 1s 到，用于计时应急时长
					
F_TIME 		EQU 	36H 		;bit0 = 1, 1秒到; 
					;bit1 = 1, 1月到; 
					;bit2 = 1, 1年到; 
					;bit3 = 1, 1分钟到。

CNT0_8MS 	EQU 	37H	 	;CNT1_8MS, CNT0_8MS组成的8bit数据达到125时，即Timer0产生125次中断后，表示1S计时已到
CNT1_8MS 	EQU 	38H 		;所以，初始化CNT1_8MS=07H, CNT0_8MS=0DH

SEC_CNT0	EQU	39H		;SEC_CNT0/1/2 以秒为单位计时
SEC_CNT1	EQU	3AH		;当数值达到1小时，即3600(E10H)秒时，向HOUR_CNT0/1进位，自身清零。
SEC_CNT2	EQU	3BH

HOUR_CNT0	EQU	3CH		;HOUR_CNT0/1 以小时为单位计时
HOUR_CNT1	EQU	3DH		;当数值达到1月时，即744(2EBH)小时时，向MONTH_CNT0/1进位，同时置F_TIME.1，自身清零。
HOUR_CNT2	EQU	3EH		

MONTH_CNT	EQU	3FH		;MONTH_CNT0/1 以月为单位计时
					;当数值达到1年时，即12(0CH)月时，，同时置F_TIME.2，自身清零。

TEMP_SUM_CY	EQU	40H		;AD子程序参数临时变量
FLAG_OCCUPIED	EQU	41H		;bit0/1/2/3 = 1时分别表示CHN0、1、6、7的转换结果(CHN0_FINAL_RET1等)正被前台使用,
					;此时ADC中断不能修改这些数据。	

FLAG_TYPE	EQU	42H		;bit0 = 1表示已经完成灯具类型选择(PORTB.3/AN7),此位为1后不再需要对AN7进行AD采样


CMP_MIN_PWR0	EQU	43H		;上电自检时，灯具电源最小电压值.(1.396V -> 0x23B ->(丢弃最低2位) 0x8E)
CMP_MIN_PWR1	EQU	44H		;

CMP_TYPE00	EQU	45H		;灯具类型门限0
CMP_TYPE01	EQU	46H		;

CMP_TYPE10	EQU	47H		;灯具类型门限1
CMP_TYPE11	EQU	48H		;

CMP_TYPE20	EQU	49H		;灯具类型门限2
CMP_TYPE21	EQU	4AH		;

LIGHT_TYPE	EQU	4BH		;灯具类型
					;bit0 = 1, 锂电池，常亮型
					;bit1 = 1, 锂电池，常灭型
					;bit2 = 1, 镍镉电池，常亮型
					;bit3 = 1, 镍镉电池，常灭型

CMP_SUPPLY0	EQU	4CH		;检测到电源电压小于此数值时，开始应急放电.(1.115V -> 0x72)
CMP_SUPPLY1	EQU	4DH

DURATION_EMER	EQU	4EH		;bit0 = 1, 应急时长小于5分钟
					;bit1 = 1, 应急时长大于5分钟，小于30分钟
					;bit2 = 1, 应急时长大于30分钟
					
CNT0_EMERGENCY	EQU	4FH		;对应急时长计时，单位s
CNT1_EMERGENCY	EQU	50H
CNT2_EMERGENCY	EQU	51H

CMP_EXIT_EMER0	EQU	52H		;检测到电池电压小于此数值时(0.96V -> 0x62)，应该关闭应急放电功能
CMP_EXIT_EMER1	EQU	53H

CMP_BAT_OPEN0	EQU	54H		;检测到电池电压大于此数值时(1.56V -> 0x9F)，视为电池充电回路开路
CMP_BAT_OPEN1	EQU	55H

CMP_BAT_FULL0	EQU	56H		;检测到电池电压大于此数值时(1.44V -> 0x93)，视为电池已充满
CMP_BAT_FULL1	EQU	57H

CMP_BAT_CHARGE0	EQU	58H		;检测到电池电压小于此数值时(1.35V -> 0x8A)，视为电池得开始充电了
CMP_BAT_CHARGE1	EQU	59H



BAT_STATE	EQU	69H		;bit0 = 0, 表示充电回路未开路；bit0 = 1, 表示充电回路开路
					;bit1 = 0, 表示电池未充满；bit1 = 1, 表示电池已充满
					;bit2 = 0, 表示电池还不需要充电；bit2 = 1, 表示电池需要充电
					;bit3 = 1, 表示电池电压过低，不能再继续应急放电了


CMP_LIGHT0	EQU	6AH		;供光源检测使用,AD转换结果小于此数值时(0.2V -> 0x14)，表示光源产生故障
CMP_LIGHT1	EQU	5AH

LIGHT_STATE	EQU	5BH		;bit0 = 1, 表示光源故障


ALARM_STATE	EQU	5CH		;bit0 = 1, 表示电池故障(开路或短路)
					;bit1 = 1, 表示光源故障(开路或短路)
					;bit2 = 1, 表示自检放电时间不足

BEEP_CTL	EQU	5DH		;bit0 = 1, 表示产生了某些故障，蜂鸣器应当每隔50秒产生持续2秒的蜂鸣					
					;bit1 = 1, 表示2秒已到，此时应禁能TCTL1.3
					;bit2 = 1, 表示50秒已到，此时应使能TCTL1.3
					;bti3 = 0, 表示正在对2秒进行计时，bit 3 = 1, 表示正在对50秒进行计时

CNT_2S		EQU	6BH		;计数器，用于计时2秒
CNT0_50S	EQU	6CH		;计数器，用于计时50秒
CNT1_50S	EQU	6DH	

ALREADY_BEEP	EQU	6EH		;bit0 = 1, 表示已经使能TIMER1
					
CNT_LED_YELLOW	EQU	5FH		;计数器，供翻转黄灯输出使用，计时单位为168MS


FLAG_SIMU_EMER	EQU	60H		;bit0 = 1, 表示在"模拟停电"状态下已经打开应急功能
					;bit1 = 1表示1s已到

CNT0_1MINUTE	EQU	61H		;每1秒加1，直至计时满1分钟为止
CNT1_1MINUTE	EQU	62H


CNT0_CHARGE	EQU	63H		;还应充电多长时间，初始值为20小时，即20 * 60 =1200分钟(0x4B0)
CNT1_CHARGE	EQU	64H
CNT2_CHARGE	EQU	65H

GREEN_FLASH	EQU	66H		;用于手动月检或手动年检时的LED闪烁
					;BIT1 = 1, 按键时长超过了3秒，绿灯开始以1HZ的频率闪烁
					;BIT2 = 1, 按键时长超过了5秒，绿灯开始以3HZ的频率闪烁


CNT_LED_GREEN	EQU	67H		;供绿色LED翻转用

;按键相关寄存器
DELAY_TIMER2	EQU	71H		;延时子程序使用
DELAY_TIMER1	EQU	72H		;延时子程序使用
DELAY_TIMER0	EQU	73H		;延时子程序使用
CLEAR_AC 	EQU 	74H 		;清除累加器A 值用寄存器
TEMP 		EQU 	75H 		;临时寄存器

;CNT0_496MS	EQU	76H		;用于定时496MS
;CNT1_496MS	EQU	77H

BTN_PRE_STA	EQU	78H		;bit0储存上一次按键状态,0:按下,1:未按下
BTN_PRESS_CNT0	EQU	79H		;按键按下时长，单位为168ms
BTN_PRESS_CNT1	EQU	68H

;led
CNT0_168MS	EQU	7AH		;用于定时168MS,供翻转LED用
CNT1_168MS	EQU	7BH

F_168MS		EQU	7CH		;每168ms将bit0 = 1, 供翻转LED使用
					;每168ms将bit1 = 1, 供按键检测使用

CMP_RESUME0	EQU	7DH		;检测到电源电压大于此数值时，表示市电供电已恢复，应关闭应急.(1.396V -> 0x8E)
CMP_RESUME1	EQU	7EH

PRESS_DURATION	EQU	7FH		;按键被按下持续时长标志
					;bit0 = 1;  被按下时长小于3秒
					;bit1 = 1;  被按下时长大于3秒，小于5秒
					;bit2 = 1;  被按下时长大于5秒，小于7秒
					;bit3 = 1;  被按下时长大于7秒

;Bank1(以下寄存器真实地址应加上80H)
;------------------------------------------------------------------
CHN0_RET0_BAK0	EQU	00H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK0	EQU	01H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK0	EQU	02H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK1	EQU	03H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK1	EQU	04H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK1	EQU	05H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK2	EQU	06H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK2	EQU	07H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK2	EQU	08H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK3	EQU	09H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK3	EQU	0AH		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK3	EQU	0BH		;ADC CHN0 转换结果高4位备份

CHN0_FINAL_RET0	EQU	0CH		;通道0平均后的结果
CHN0_FINAL_RET1	EQU	0DH		;
CHN0_FINAL_RET2	EQU	0EH

DET0_CT		EQU	0FH		;ADC 通道0 转换结果个数

;------------------------------------------------------------------
CHN1_RET0_BAK0	EQU	10H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK0	EQU	11H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK0	EQU	12H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK1	EQU	13H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK1	EQU	14H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK1	EQU	15H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK2	EQU	16H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK2	EQU	17H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK2	EQU	18H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK3	EQU	19H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK3	EQU	1AH		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK3	EQU	1BH		;ADC CHN1 转换结果高4位备份

CHN1_FINAL_RET0	EQU	1CH		;通道1平均后的结果
CHN1_FINAL_RET1	EQU	1DH		;
CHN1_FINAL_RET2	EQU	1EH		;

DET1_CT		EQU	1FH		;ADC 通道1 转换结果个数

;------------------------------------------------------------------
CHN6_RET0_BAK0	EQU	20H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK0	EQU	21H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK0	EQU	22H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK1	EQU	23H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK1	EQU	24H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK1	EQU	25H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK2	EQU	26H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK2	EQU	27H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK2	EQU	28H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK3	EQU	29H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK3	EQU	2AH		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK3	EQU	2BH		;ADC CHN6 转换结果高4位备份

CHN6_FINAL_RET0	EQU	2CH		;通道6平均后的结果
CHN6_FINAL_RET1	EQU	2DH		;
CHN6_FINAL_RET2	EQU	2EH

DET6_CT		EQU	2FH		;ADC 通道6 转换结果个数

;------------------------------------------------------------------
CHN7_RET0_BAK0	EQU	30H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK0	EQU	31H		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK0	EQU	32H		;ADC CHN7 转换结果高4位备份

CHN7_RET0_BAK1	EQU	33H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK1	EQU	34H		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK1	EQU	35H		;ADC CHN7 转换结果高4位备份

CHN7_RET0_BAK2	EQU	36H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK2	EQU	37H		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK2	EQU	38H		;ADC CHN7 转换结果高4位备份

CHN7_RET0_BAK3	EQU	39H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK3	EQU	3AH		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK3	EQU	3BH		;ADC CHN7 转换结果高4位备份

CHN7_FINAL_RET0	EQU	3CH		;通道7平均后的结果
CHN7_FINAL_RET1	EQU	3DH		;
CHN7_FINAL_RET2	EQU	3EH		;

DET7_CT		EQU	3FH		;ADC 通道7 转换结果个数


;*****************************************************
;程序
;*****************************************************
	ORG	0000H

	;中断向量表
	JMP	RESET			;RESET ISP
	JMP	ADC_ISP			;ADC INTERRUPT ISP
	JMP	TIMER0_ISP		;TIMER0 ISP
	JMP	TIMER1_ISP		;TIMER1 ISP
	RTNI				;PORTB/D ISP


;*****************************************************
;Timer0 中断服务程序
;Timer0已配置为每8ms产生一次中断
;
;*****************************************************
TIMER0_ISP:
	STA 	AC_BAK,		00H 	;备份AC 值
	ANDIM 	IRQ,		1011B 	;清TIMER0 中断请求标志

J_168MS:
	SBIM	CNT0_168MS,	01H
	LDI	TBR,		00H
	SBCM	CNT1_168MS
	BC	J_1S

	LDI	CNT0_168MS,	04H	;8ms * 21 = 168ms
	LDI	CNT1_168MS,	01H

	ORIM	F_168MS,	0011B	;设置 "168ms 到"标志，1)bit0供翻转LED用，2)bit1供按键检测用

J_1S:	
	SBIM 	CNT0_8MS,	01H	;每次Timer0中断产生后，将CNT0_8MS减1
	LDI	TBR,		00H
	SBCM	CNT1_8MS		;每次CNT0_8MS-1产生借位时，将CNT1_8MS减1
	BC	TIMER0_ISP_END
	
	LDI 	CNT0_8MS,	0CH 	;重置1s 计数器 1S = 125 * 8 MS
	LDI 	CNT1_8MS,	07H 	;重置1s 计数器
	
	ORIM 	F_TIME,		0001B 	;设置 "1s 到"标志
	ORIM	F_1S,		0001B	;为应急功能提供 "1s 到"标志
	ORIM	FLAG_SIMU_EMER,	0010B	;为手动自检提供 "1s 到"标志

BEEP_TIMER:
	LDA	BEEP_CTL		;判断当前正在计时2秒还是50秒
	BA3	CNTING_50S		;如果正在对50秒进行计时，则跳转
CNTING_2S:
	ADIM	CNT_2S,		01H	;2秒计数器每秒累加1
	BA1	J_2S			;如果2秒已到，则跳转
	JMP	J_MINUTE
J_2S:
	LDI	CNT_2S,		00H	;清零2秒计数器
	LDI	CNT0_50S,	01H	;重置50秒计数器
	LDI	CNT1_50S,	03H
	ORIM	BEEP_CTL,	0010B	;置"2秒 到"标志	
	JMP	J_MINUTE
CNTING_50S:
	SBIM	CNT0_50S,	01H	;50秒计数器每秒减1
	LDI	TBR,		00H
	SBCM	CNT1_50S
	BC	J_MINUTE		;如果还没到50秒，则跳转

	LDI	CNT_2S,		00H	;清零2秒计数器
	LDI	CNT0_50S,	01H	;重置50秒计数器
	LDI	CNT1_50S,	03H
	ORIM	BEEP_CTL,	0100B	;置"50s 到"标志
	
J_MINUTE:
	SBIM	CNT0_1MINUTE,	01H
	LDI	TBR,		00H
	SBCM	CNT1_1MINUTE
	BC	J_HOUR			;因为J_HOUR是以秒为单位累加，所以应跳至J_HOUR

	LDI	CNT0_1MINUTE,	0BH	;0x3c * 1s = 60s
	LDI	CNT1_1MINUTE,	03H

	ORIM	F_TIME,		1000B	;设置 "1分钟 到"标志	

J_HOUR:
	SBIM	SEC_CNT0,	01H	;SEC_CNT0 每秒减1
	LDI	TBR,		00H
	SBCM	SEC_CNT1		;每次SEC_CNT0-1产生借位时，将SEC_CNT1减1
	LDI	TBR,		00H
	SBCM	SEC_CNT2		;每次SEC_CNT1-1产生借位时，将SEC_CNT2减1
	BC	TIMER0_ISP_END		;SEC_CNT2减1产生借位时，则表示1小时计时已到
	
	LDI 	SEC_CNT0,	0FH 	;重置SEC_CNT0/1/2 为E10H-1(3600-1)
	LDI 	SEC_CNT1,	00H
	LDI 	SEC_CNT2,	0EH
	
J_MONTH:	
	SBIM 	HOUR_CNT0,	01H	;HOUR_CNT0 每小时减1
	LDI	TBR,		00H
	SBCM	HOUR_CNT1		;每次 HOUR_CNT0 产生借位时，将 HOUR_CNT1 减1
	BC	TIMER0_ISP_END		;HOUR_CNT1 减1产生借位时，则表示1月计时已到
	
	LDI 	HOUR_CNT0,	07H 	;重置HOUR_CNT0/1/2 为2E8H-1(744-1)
	LDI 	HOUR_CNT1,	0EH
	LDI	HOUR_CNT2,	02H
	
	ORIM 	F_TIME,		0010B 	;设置 "1月到" 标志
	
J_YEAR:	
	SBIM 	MONTH_CNT,	01H	;MONTH_CNT 每月减1
	BC 	TIMER0_ISP_END		;MONTH_CNT 减1产生借位时，则表示1年计时已到
	
	LDI 	MONTH_CNT,	0BH 	;重置MONTH_CNT 为0CH-1(12-1)
	
	ORIM 	F_TIME,		0100B 	;设置 "1年到" 标志

TIMER0_ISP_END:
	LDI 	IE,		1110B 	;打开ADC,Timer0,Timer1 中断
	LDA 	AC_BAK,		00H 	;恢复AC 值
	RTNI


;*****************************************************
;Timer1 中断服务程序
;Timer1已配置为每秒产生约4k次中断
;
;*****************************************************
TIMER1_ISP:
	STA 	AC_BAK,		00H 	;备份AC 值
	ANDIM 	IRQ,		1101B 	;清TIMER1 中断请求标志

	EORIM	PORTC,		1000B	;翻转PC.3，产生蜂鸣
	
TIMER1_ISP_END:
	LDI 	IE,		1110B 	;打开ADC,Timer0,Timer1 中断
	LDA 	AC_BAK,		00H 	;恢复AC 值
	RTNI

;*****************************************************
;ADC 中断服务程序
;*****************************************************	
ADC_ISP:
	STA 	AC_BAK,		00H 	;备份AC 值
	ANDIM 	IRQ,		0111B 	;清ADC 中断请求标志

	LDA	ADCCHN			
	BAZ	CHN0_VOL_1		;此次为通道0 转换结果
	SBI	ADCCHN,		01H
	BAZ	CHN1_VOL_1		;此次为通道1 转换结果	
	SBI	ADCCHN,		06H
	BAZ	CHN6_VOL_1		;此次为通道6 转换结果
	SBI	ADCCHN,		07H
	BAZ	CHN7_VOL_1		;此次为通道7 转换结果
	JMP	ADC_ISP_END		;正常情况下不应执行此语句

;----------------------------------------------------------------	

;转存通道0 转换结果
;----------------------------------------------------------------
CHN0_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET0_CT,	01H	

	LDI	TBR,		04H	;DET0_CT - 4 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET0_CT - 3 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET0_CT - 2 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_12		;第2个转换结果

CHN0_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN0_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN0_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN0_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN0_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN0_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN0_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN0_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET0_CT 清0
	STA	DET0_CT,	01H
	
	CALL	CAL_CHN0_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;转存通道1 转换结果
;----------------------------------------------------------------
CHN1_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET1_CT,	01H	

	LDI	TBR,		04H	;DET1_CT - 4 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET1_CT - 3 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET1_CT - 2 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_12		;第2个转换结果

CHN1_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN1_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN1_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN1_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK1,	01H
	JMP 	NEXT_CHN

CHN1_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN1_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK2,	01H
	JMP 	NEXT_CHN	

CHN1_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN1_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET1_CT 清0
	STA	DET1_CT,	01H
	
	CALL	CAL_CHN1_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;转存通道6 转换结果
;----------------------------------------------------------------
CHN6_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET6_CT,	01H	

	LDI	TBR,		04H	;DET6_CT - 4 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET6_CT - 3 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET6_CT - 2 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_12		;第2个转换结果

CHN6_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN6_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN6_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN6_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN6_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN6_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN6_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN6_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET6_CT 清0
	STA	DET6_CT,	01H
	
	CALL	CAL_CHN6_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;转存通道7 转换结果
;----------------------------------------------------------------
CHN7_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET7_CT,	01H	

	LDI	TBR,		04H	;DET7_CT - 4 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET7_CT - 3 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET7_CT - 2 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_12		;第2个转换结果

CHN7_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN7_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN7_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN7_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN7_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN7_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN7_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN7_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET7_CT 清0
	STA	DET7_CT,	01H
	
	CALL	CAL_CHN7_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------

;----------------------------------------------------------------	
NEXT_CHN:
	LDA	ADCCHN
	BAZ	NEXT_CHN1
	SBI	ADCCHN,		01H
	BAZ	NEXT_CHN6
	SBI	ADCCHN,		06H
	BAZ	NEXT_CHN7
	SBI	ADCCHN,		07H
	BAZ	NEXT_CHN0
	
	JMP 	ADC_ISP_END		;不可能执行这一句

NEXT_CHN0:
	LDI	ADCCHN,		00H	;设定为CHN0
	JMP 	ADC_ISP_END

NEXT_CHN1:
	LDI	ADCCHN,		01H	;设定为CHN1
	JMP 	ADC_ISP_END
	
NEXT_CHN6:
	LDI 	ADCCHN,		06H 	;设定为CHN6
	JMP	ADC_ISP_END

NEXT_CHN7:
	LDA	FLAG_TYPE
	BA0	NEXT_CHN0		;若FLAG_TYPE的bit0=1，则表示已完成灯具类型选择，此时不再需要对AN7进行采样。
	
	LDI	ADCCHN,		07H	;设定为CHN7
;----------------------------------------------------------------


ADC_ISP_END:
	ORIM 	ADCCFG,		1000B 	;启动A/D 转换

	LDI 	IE,		1110B 	;打开ADC,Timer0,Timer1 中断
	LDA 	AC_BAK,		00H 	;取出AC 值
	RTNI


;*****************************************************
; 主程序
;*****************************************************
RESET:
	NOP	
	LDI 	IE,		0000B	;关闭所有中断
 	NOP

	CALL	RESET_USER_DATA		;清除用户寄存器
	CALL	REGISTER_INITIAL	;初始化系统寄存器与用户数据寄存器

	CALL	PRE_START_PWR_CHK	;检查主电源是否正常，如异常则一直等待，直至恢复
	CALL	PRE_START_TYPE_CHK	;判断灯具的电池类型与光源类型
	
	CALL	CHARGE_BAT_ENABLE	;上电后，即开始对电池进行充电

MAIN_LOOP:
	CALL	CHARGE_BAT_CTRL		;[充电控制]  根据主电源状态、待充电时长、电池是否充满标志位等进行电池充电控制
	CALL	EMERGENCY_CTRL		;[放电控制]  主电源停电后的应急放电控制，退出应急状态时，计算此次应急放电时长
	
	CALL	KEY_PROCESS		;[按键扫描]  按键扫描
	CALL	SELF_CHK_STATE		;[自检状态]  根据系统运行时长与按键时长，置"停电"，"月检"，"年检"标志位
	CALL	SELF_CHK_PROCESS	;[系统自检]  根据自检标志位，进行自检，只判断放电时长是否够长

	CALL	BAT_STATE_CHK		;[电池状态]  检测电池状态，并置相应标志位
	CALL	LIGHT_STATE_CHK		;[光源状态]  光源状态检测，并置相应标志位
	CALL	TIPS_PROCESS		;[声光提示]  处理LED与蜂鸣器

	JMP	MAIN_LOOP


;*****************************************************
;清用户寄存器($030 ~ $0EF)
;*****************************************************
RESET_USER_DATA:

POWER_RESET:
	LDI 	DPL,		00H
	LDI 	DPM,		03H
	LDI 	DPH,		00H	;从$30 开始

POWER_RESET_1:
	LDI 	INX,		00H	;向DPH,DPM,DPL组成的地址处写0
	ADIM 	DPL,		01H
	LDI 	TBR,		00H	;将累加器A 清0
	ADCM 	DPM,		00H
	BA3 	POWER_RESET_2
	JMP 	POWER_RESET_3

POWER_RESET_2:
	ADIM 	DPH,		01H

POWER_RESET_3:
	SBI 	DPH,		01H	;到$EF 结束，即在地址001 111 000B时停止
	BNZ 	POWER_RESET_1
	SBI 	DPM,		07H
	BNZ 	POWER_RESET_1

RESET_USER_DATA_END:
	RTNI


;*****************************************************
;初始化系统寄存器
;*****************************************************
REGISTER_INITIAL:

	;TIMER0 初始化
	;
	;  fosc=4M, fsys=4M/4=1M
	;
	;  fsys=1M                 31250Hz                   125Hz
	;           -------------            -------------
	;  -------->| Prescaler |----------->|  Counter  |----------->
	;           -------------            -------------
	;               (32)                     (250)
	
	LDI 	TM0,		03H 	;设置TIMER0 预分频为/32
	LDI 	TL0,		06H
	LDI 	TH0,		00H 	;设置中断时间为8ms

	LDI	CNT0_168MS,	04H	;定时168ms
	LDI	CNT1_168MS,	01H	;

	LDI 	CNT0_8MS,	0DH 	;定时1s
	LDI 	CNT1_8MS,	07H 	;定时1s

	LDI	CNT0_50S,	01H	;Beep定时50s
	LDI	CNT1_50S,	03H
	
	LDI	SEC_CNT0,	0FH	;SEC_CNT0/1/2 初始化为E10H - 1，即3600 -1
	LDI	SEC_CNT1,	00H
	LDI	SEC_CNT2,	0EH

	LDI	HOUR_CNT0,	07H	;HOUR_CNT0/1/2 初始化为2E8H - 1，即744 - 1
	LDI	HOUR_CNT1,	0EH
	LDI	HOUR_CNT2,	02H

	LDI	MONTH_CNT,	0BH	;MONTH_CNT 初始化为12 -1 个月

	;TIMER1 初始化
	;
	;  fosc=4M, fsys=4M/4=1M
	;
	;  fsys=1M                 31250Hz                   3906.25Hz
	;           -------------            -------------
	;  -------->| Prescaler |----------->|  Counter  |----------->
	;           -------------            -------------
	;               (32)                     (8)		
	LDI 	TM1,		03H 	;设置TIMER0 预分频为/32
	LDI 	TL1,		08H
	LDI 	TH1,		0FH 	;设置中断频率约4kHz
	LDI	TCTL1,		08H	;上电蜂鸣一声，之后会关闭

	;I/O 口初始化
	LDI 	PORTA,		00H
	LDI 	PACR,		00H 	;设置PortA 作为输入口
	
	LDI 	PORTB,		00H
	LDI 	PBCR,		00H 	;设置PortB 作为输入口

	LDI	PORTC,		00H
	LDI	PCCR,		0FH	;设置PortC.0/PortC.1/PortC.2/PortC.3 作为输出
	
	LDI 	PDCR,		1110B 	;设置PD.0为输入，PD.3为输出
	LDI	TBR,		0001B	;打开PD.0 内部上拉电阻
	STA	PPDCR

	LDI 	PORTE,		0010B	;PE.1继电器输出高电平
	LDI 	PECR,		0FH 	;设置PortE 作为输出口

	;ADC初始化
	;tosc = 1/4M = 0.25us, tAD = 8tosc = 2us, 一次A/D 转换时间 = 204tAD = 408 us.
	LDI 	PACR,		0000B 	;设置PortA0/1 作为输入口
	LDI 	PBCR,		0000B 	;设置PortB2/3 作为输入口
	LDI 	ADCCTL,		0001B 	;选择内部参考电压VDD，使能ADC
	LDI 	ADCCFG,		0100B 	;A/D 时钟tAD=8tOSC, A/D 转换时间= 204tAD
	LDI	ADCPORT,	1100B	;使用AN0 ~ AN7
	LDI	ADCCHN,		00H	;选择AN0
	ORIM 	ADCCFG,		1000B 	;启动A/D 转换

	;PWM初始化
	LDI	PWMC0,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP00,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP01,		07H	
	LDI	PWMD00,		00H	;无微调
	LDI	PWMD01,		0EH	;占空比为50%
	LDI	PWMD02,		03H	

	LDI	PWMC1,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP10,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP11,		07H	
	LDI	PWMD10,		00H	;无微调
	LDI	PWMD11,		0EH	;占空比为50%
	LDI	PWMD12,		03H


	;按键相关
	;LDI	CNT0_496MS,	0DH	;初始化496ms 计数器,496 = 8 * 62
	;LDI	CNT0_496MS,	03H	;初始化496ms 计数器
	LDI	BTN_PRE_STA,	01H	;初始化上一次没有按键

	;状态相关
	LDI	SYSTEM_STATE,	00H	;初始化为"主电"

	;门限值
	LDI	CMP_MIN_PWR0,	0EH	;最小上电电压(1.396V -> 0x8E)
	LDI	CMP_MIN_PWR1,	08H	

	LDI	CMP_SUPPLY0,	02H	;小于此电压，则开启应急功能(1.115V -> 0x72)
	LDI	CMP_SUPPLY1,	07H

	LDI	CMP_RESUME0,	0EH	;大于此电压，则由应急转入主电(1.396V -> 0x8E)
	LDI	CMP_RESUME1,	08H

	LDI	CMP_EXIT_EMER0,	02H	;电池电压小于此电压时，关闭应急功能(0.96V -> 0x62)
	LDI	CMP_EXIT_EMER1,	06H

	LDI	CMP_BAT_OPEN0,	0FH	;电池电压大于此电压时，视为电池充电回路开路(1.56V -> 0x9F)
	LDI	CMP_BAT_OPEN1,	09H

	LDI	CMP_BAT_FULL0,	03H	;检测到电池电压大于此数值时(1.44V -> 0x93)，视为电池已充满
	LDI	CMP_BAT_FULL1,	09H

	LDI	CMP_BAT_CHARGE0,0AH	;检测到电池电压小于此数值时(1.35V -> 0x8A)，视为电池得开始充电了
	LDI	CMP_BAT_CHARGE1,08H

	LDI	CMP_LIGHT0,	04H	;供光源检测使用,AD转换结果小于此数值时(0.2V -> 0x14)，表示光源产生故障
	LDI	CMP_LIGHT1,	01H
	
	LDI	CMP_TYPE00,	0DH	;灯具类型门限0   (0.6V -> 0x3D)
	LDI	CMP_TYPE01,	03H

	LDI	CMP_TYPE10,	0AH	;灯具类型门限1   (1.2V -> 0x7A)
	LDI	CMP_TYPE11,	07H

	LDI	CMP_TYPE20,	08H	;灯具类型门限2   (1.8V -> 0xB8)
	LDI	CMP_TYPE21,	0BH

	LDI	CNT0_CHARGE,	0FH	;还应充电多长时间，初始值为20小时，即20 * 60 =1200分钟(0x4B0)
	LDI	CNT1_CHARGE,	0AH
	LDI	CNT2_CHARGE,	04H
	
	LDI 	IRQ,		00H
	LDI 	IE,		1110B 	;打开ADC,Timer0,Timer1 中断


REGISTER_INITIAL_END:
	RTNI



;*****************************************************
;检查供电是否正常
;*****************************************************
PRE_START_PWR_CHK:

WAIT_AD_RESULT:
	;一个通道采样4个数据，去掉最小与最大值，将余下的2个数据平均后得到最终结果。
	;上述过程耗时约408us * 4 = 2ms
	;根据以上推断，四个通道各得出一个最终结果需耗时 2ms * 4 = 8ms

	;保险起见，此处延时20ms
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS

	LDI	TCTL1,		00H	;关闭Timer1，停止蜂鸣

WAIT_PWR_NML:	
	ORIM	FLAG_OCCUPIED,	0100B	;锁定通道6最终结果

	LDA	CHN6_FINAL_RET1,01H
	SUB	CMP_MIN_PWR0
	LDA	CHN6_FINAL_RET2,01H
	SBC	CMP_MIN_PWR1

	ANDIM	FLAG_OCCUPIED,	1011B	;释放对通道6最终结果的锁定
	
	BC	WAIT_AD_RESULT		;如果未达到最小上电电压，则一直等待电压升至最小上电电压之上。

PRE_START_PWR_CHK_END:
	RTNI



;***********************************************************
; 检查灯具类型
; 输入: CHN7_FINAL_RET1, CHN7_FINAL_RET2
; 输出: LIGHT_TYPE
;***********************************************************
PRE_START_TYPE_CHK:

	ORIM	FLAG_OCCUPIED,	1000B	;锁定通道7最终结果

	LDA	CHN7_FINAL_RET1,01H	;和门限0比较
	SUB	CMP_TYPE00
	LDA	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE01
	BC	LI_ON			;如果检测到的电压小于0.6V，则灯具为锂电池，常亮型

	LDA	CHN7_FINAL_RET1,01H	;和门限1比较
	SUB	CMP_TYPE10
	LDA	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE11
	BC	LI_OFF			;如果检测到的电压小于1.2V，则灯具为锂电池，常灭型

	LDA	CHN7_FINAL_RET1,01H	;和门限2比较
	SUB	CMP_TYPE20
	LDA	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE21
	BC	NI_ON			;如果检测到的电压小于1.8V，则灯具为镍镉电池，常亮型

NI_OFF:					;如果检测到的电压大于1.8V，则灯具为镍镉电池，常灭型
	LDI	LIGHT_TYPE,	1000B
	JMP	PRE_START_TYPE_CHK_END
	
LI_ON:
	LDI	LIGHT_TYPE,	0001B
	JMP	PRE_START_TYPE_CHK_END
	
LI_OFF:
	LDI	LIGHT_TYPE,	0010B
	JMP	PRE_START_TYPE_CHK_END
	
NI_ON:
	LDI	LIGHT_TYPE,	0100B
	
PRE_START_TYPE_CHK_END:
	ANDIM	FLAG_OCCUPIED,	0111B	;释放对通道7最终结果的锁定
	ORIM	FLAG_TYPE,	0001B	;不再对通道7进行采样
	
	RTNI





;***********************************************************
; 通过PWM1输出高电平，对电池进行充电
;***********************************************************
CHARGE_BAT_ENABLE:

	LDI	PWMC1,		0000B	;PWM1 Clock = tosc = 4M
	LDI	PWMP10,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP11,		07H	
	LDI	PWMD10,		00H	;无微调
	LDI	PWMD11,		0DH	;占空比为100%
	LDI	PWMD12,		07H
	ORIM	PWMC1,		0001B	;使能PWM1输出

	ORIM	ALREADY_ENTER,	0001B	;置已经开始充电标志位
	LDI	CNT0_CHARGE,	0FH
	LDI	CNT1_CHARGE,	0AH
	LDI	CNT2_CHARGE,	04H

CHARGE_BAT_ENABLE_END:
	RTNI


;***********************************************************
; 对于锂电池，通过PWM1输出低电平，停止对电池充电
; 对于镍镉电池，通过PWM1输出频率2K,1/4点空比的方波，对电池进行涓流充电
;***********************************************************
CHARGE_BAT_DISABLE:
	LDA	TBR,		0011B
	AND	LIGHT_TYPE		;判断电池类型
	BNZ	LI_BAT

NI_BAT:
	LDI	PWMC1,		0110B	;PWM1 Clock = 8 * tosc = 2us
	LDI	PWMP10,		0AH	;周期为250个PWM0 Clock
	LDI	PWMP11,		0FH	
	LDI	PWMD10,		00H	;无微调
	LDI	PWMD11,		0EH	;占空比为1/4
	LDI	PWMD12,		03H
	ORIM	PWMC1,		0001B	;使能PWM1输出
	
	JMP	CHARGE_BAT_DISABLE_END

LI_BAT:
	LDI	PWMC1,		0000B	;PWM1 Clock = tosc = 4M
	LDI	PWMP10,		00H	;周期为0个PWM0 Clock
	LDI	PWMP11,		00H	
	LDI	PWMD10,		00H	;无微调
	LDI	PWMD11,		0DH	;占空比为100%
	LDI	PWMD12,		07H
	ORIM	PWMC1,		0001B	;使能PWM1输出

CHARGE_BAT_DISABLE_END:
	ANDIM	ALREADY_ENTER,	1110B	;清已经开始充电标志位
	RTNI


;***********************************************************
;电池充电控制
;***********************************************************
CHARGE_BAT_CTRL:

	ORIM	FLAG_OCCUPIED,	0100B	;锁定通道6最终结果

	LDA	CHN6_FINAL_RET1,01H
	SUB	CMP_SUPPLY0
	LDA	CHN6_FINAL_RET2,01H
	SBC	CMP_SUPPLY1

	ANDIM	FLAG_OCCUPIED,	1011B	;释放对通道6最终结果的锁定

	BC	SET_PWR_DOWN_BIT	;如果停电,则跳转

	LDA	ALREADY_ENTER		;如果主电源供电正常，则检查是否已经进入充电状态
	BA0	CHARGE_DURATION		;如果已经进入充电状态

	ADI	BAT_STATE,	0100B		
	BA2	CHARGE_BAT_CTRL_END	;不需要对电池充电
	
	CALL	CHARGE_BAT_ENABLE	;如果电池电压过低，则开始对电池充电

	JMP	CHARGE_BAT_CTRL_END	;不需要对电池充电
	
CHARGE_DURATION:
	ADI	F_TIME,		1000B
	BA3	IS_BAT_FULL		;1分钟未到

	ANDIM	F_TIME,		0111B	;清1分钟到标志位

	SBIM	CNT0_CHARGE,	01H	;待充电时长减1分钟
	LDI	TBR,		00H
	SBCM	CNT1_CHARGE
	LDI	TBR,		00H
	SBCM	CNT2_CHARGE

	BNC	STOP_CHARGE		;
	
IS_BAT_FULL:
	LDA	BAT_STATE
	BA1	STOP_CHARGE		;电池已充满
	
	JMP	CHARGE_BAT_CTRL_END
	
STOP_CHARGE:
	CALL	CHARGE_BAT_DISABLE
	JMP	CHARGE_BAT_CTRL_END

SET_PWR_DOWN_BIT:
	ORIM	SYSTEM_STATE,	0001B

CHARGE_BAT_CTRL_END:
	RTNI


;***********************************************************
;打开应急放电
;通过PWM0输出频率为32KHZ，占空比为50%的方波，以此驱动应急电路
;置停电标志位
;置进入应急放电标志位
;应急时长清零
;***********************************************************
EMERGENCY_ENABLE:
	ORIM	SYSTEM_STATE,	0001B	;置停电标志位
	ORIM	ALREADY_ENTER,	0010B	;置标志位，表明已打开应急放电功能
	
	LDI	CNT0_EMERGENCY,	00H	;应急时长清零
	LDI	CNT1_EMERGENCY,	00H
	LDI	CNT2_EMERGENCY,	00H

	LDI	PWMC0,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP00,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP01,		07H	
	LDI	PWMD00,		00H	;无微调
	LDI	PWMD01,		0EH	;占空比为50%
	LDI	PWMD02,		03H
	ORIM	PWMC0,		0001B	;使能PWM0输出

EMERGENCY_ENABLE_END:
	RTNI


;***********************************************************
;禁能PWM0，关闭应急功能
;***********************************************************
EMERGENCY_DISABLE:
	LDI	PWMC0,		0000B	;禁能PWM0

EMERGENCY_DISABLE_END:
	RTNI


;***********************************************************
; 发生了应急放电事件，重新计算待充电时长
;***********************************************************
RE_CALC_TIME:
	LDA	DURATION_EMER
	BA0	BETWEEN_0_5
	BA1	BETWEEN_5_30
	BA2	OVER_30

BETWEEN_0_5:
	ADIM	CNT0_CHARGE,	05H	;将待充电时长增加5分钟
	LDI	TBR,		00H
	ADCM	CNT1_CHARGE
	LDI	TBR,		00H
	ADCM	CNT2_CHARGE

	JMP	ADJUST_TIME
	
BETWEEN_5_30:
	ADIM	CNT0_CHARGE,	08H	;将待充电时长增加10小时
	LDI	TBR,		05H
	ADCM	CNT1_CHARGE
	LDI	TBR,		02H
	ADCM	CNT2_CHARGE

	JMP	ADJUST_TIME
	
OVER_30:				;即使20+20小时，也不会发生溢出
	ADIM	CNT0_CHARGE,	00H	;将待充电时长增加20小时
	LDI	TBR,		0BH
	ADCM	CNT1_CHARGE
	LDI	TBR,		04H
	ADCM	CNT2_CHARGE
	
ADJUST_TIME:
	SUB	CNT0_CHARGE,	00H	;将待充电时长与20小时作比较
	LDI	TBR,		0BH
	SBC	CNT1_CHARGE
	LDI	TBR,		04H
	SBC	CNT2_CHARGE

	BNC	RE_CALC_TIME_END	;待充电时长小于20小时

	LDI	CNT0_CHARGE,	00H	;将待充电时长设置为20小时
	LDI	CNT1_CHARGE,	0BH
	LDI	CNT2_CHARGE,	04H
		
RE_CALC_TIME_END:
	RTNI


;***********************************************************
;应急放电控制
;主电源停电后的应急放电控制。
;何时开始应急放电:主电源AD引脚电压低于1.115V后
;何时停止应急放电:主电源AD引脚电压高于1.396V后，或是电池耗尽(电池AD引脚电压低于0.96V)，或是按键长按7秒亦可停止应急放电
;停止应急放电时，得出应急放电时长
;***********************************************************
EMERGENCY_CTRL:
	ORIM	FLAG_OCCUPIED,	0100B	;锁定通道6最终结果

	LDA	CHN6_FINAL_RET1,01H
	SUB	CMP_SUPPLY0
	LDA	CHN6_FINAL_RET2,01H
	SBC	CMP_SUPPLY1

	ANDIM	FLAG_OCCUPIED,	1011B	;释放对通道6最终结果的锁定


	BNC	CHK_PWR_RESUME		;如果主电源引脚电压大于1.115V，则跳转

	LDA	ALREADY_ENTER		;如果主电源引脚电压小于1.115V，则检查是否已经进入应急状态
	BA1	EMERGENCY_CNT		;如果已经进入应急状态，则跳转

	CALL	EMERGENCY_ENABLE	;如果停电且还未进入应急状态,则打开应急
	JMP	EMERGENCY_CTRL_END


CHK_PWR_RESUME:
	ORIM	FLAG_OCCUPIED,	0100B	;锁定通道6最终结果

	LDA	CHN6_FINAL_RET1,01H
	SUB	CMP_RESUME0
	LDA	CHN6_FINAL_RET2,01H
	SBC	CMP_RESUME1

	ANDIM	FLAG_OCCUPIED,	1011B	;释放对通道6最终结果的锁定

	BC	SMALL_THAN_1P396V	;如果1.115v < X < 1.396V

	LDA	ALREADY_ENTER		;X > 1.396V
	BA1	STOP_EMERGENCY		;如果已经进入应急状态，则跳转
	JMP	EMERGENCY_CTRL_END


SMALL_THAN_1P396V:
	LDA	ALREADY_ENTER		;检查是否已经进入应急状态
	BA1	EMERGENCY_CNT		;如果已经进入应急状态，则跳转
	JMP	EMERGENCY_CTRL_END


STOP_EMERGENCY:
	ANDIM	SYSTEM_STATE,	1110B	;清除停电标志位
	ANDIM	ALREADY_ENTER,	1101B	;清除已经开始应急标志位

BAT_DOWN:	
	CALL	EMERGENCY_DISABLE

	SBI	CNT0_EMERGENCY,	0CH	;和5分钟比较(0x12C)
	LDI	TBR,		02H
	SBC	CNT1_EMERGENCY
	LDI	TBR,		01H
	SBC	CNT2_EMERGENCY

	BNC	LESS_5_MINUTE		;应急时长小于5分钟

	SBI	CNT0_EMERGENCY,	08H	;和30分钟比较(0x708)
	LDI	TBR,		00H
	SBC	CNT1_EMERGENCY
	LDI	TBR,		07H
	SBC	CNT2_EMERGENCY

	BNC	LESS_30_MINUTE		;应急时长小于30分钟

MORE_30_MINUTE:				;应急时长大于30分钟
	ORIM	DURATION_EMER,	0100B
	CALL	RE_CALC_TIME		;发生了应急放电事件，重新计算待充电时长
	JMP	EMERGENCY_CTRL_END

LESS_5_MINUTE:
	ORIM	DURATION_EMER,	0001B
	CALL	RE_CALC_TIME		;发生了应急放电事件，重新计算待充电时长
	JMP	EMERGENCY_CTRL_END
	
LESS_30_MINUTE:
	ORIM	DURATION_EMER,	0010B
	CALL	RE_CALC_TIME		;发生了应急放电事件，重新计算待充电时长
	JMP	EMERGENCY_CTRL_END
	

EMERGENCY_CNT:
	ADI	PRESS_DURATION,	1000B	;判断按键是否被按下超过7秒
	BA3	EMERG_CNT_START

	CALL	EMERGENCY_DISABLE	;关闭应急
	STOP				;系统停止工作

EMERG_CNT_START:	
	ADI	F_1S,		0001B	;每秒检查一次
	BA0	EMERGENCY_BATTERY

	ANDIM	F_1S,		1110B	;清除1s标志位
	SBI	CNT2_EMERGENCY,	08H	;如果CNT达到0x800，则表示已应急放电0x800s = 2048s > 30min
	BC	EMERGENCY_BATTERY	;此时无需再对应急放电时长计时

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

EMERGENCY_BATTERY:			;检查电池是否已经耗尽
	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDA	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDA	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

	BNC	EMERGENCY_CTRL_END
	JMP	BAT_DOWN		;


EMERGENCY_CTRL_END:
	RTNI



;***********************************************************
;检查电池电压。
;根据所测得电池电压结果，置相应电池状态标志位
;输出
;-- BAT_STATE		电池状态，位图形式表示
;-- ALARM_STATE.0		故障标志位
;***********************************************************
BAT_STATE_CHK:

	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDA	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_OPEN0		;判断电池是否开路
	LDA	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_OPEN1
	BNC	BAT_OPEN		;AD转换结果大于1.56V，电池开路
	ANDIM	BAT_STATE,	1110B	;清除充电回路开路标志位
	ANDIM	ALARM_STATE,	1110B	;清除充电回路开路故障标志位

	LDA	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_FULL0		;判断电池是否充满
	LDA	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_FULL1
	BNC	BAT_FULL		;AD转换结果大于1.44V，电池已充满
	ANDIM	BAT_STATE,	1101B	;清除电池已充满标志位

	LDA	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_CHARGE0		;判断电池是否过低，需要充电了
	LDA	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_CHARGE1
	BC	BAT_NEED_CHARGE		;AD转换结果小于1.35V，电池需要重新充电
	JMP	BAT_STATE_CHK_END

BAT_OPEN:
	ORIM	BAT_STATE,	0001B	;置充电回路开路标志位
	ORIM	ALARM_STATE,	0001B	;置充电回路开路故障标志位

	ADI	SELF_STATE,	1000B	;判断是否处于手动自检状态
	BA3	BAT_STATE_CHK_END
	ORIM	BEEP_CTL,	0001B	;在手动自检状态下，检测到充电回路开路故障，此时蜂鸣器应每50秒蜂鸣2秒
	
	JMP	BAT_STATE_CHK_END

BAT_FULL:
	ORIM	BAT_STATE,	0010B	;置电池已充满标志位
	ANDIM	BAT_STATE,	1011B	;清电池需要重新充电标志位
	JMP	BAT_STATE_CHK_END

BAT_NEED_CHARGE:
	ORIM	BAT_STATE,	0100B	;置电池需要重新充电标志位
	JMP	BAT_STATE_CHK_END

BAT_STATE_CHK_END:
	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定
	RTNI


;***********************************************************
;根据通道0转换结果，检测光源状态，并设置光源故障标志位
;***********************************************************
PROCESS_LIGHT:

	ORIM	FLAG_OCCUPIED,	0001B	;锁定通道0最终结果

	LDA	CHN0_FINAL_RET1,01H
	SUB	CMP_LIGHT0
	LDA	CHN0_FINAL_RET2,01H
	SBC	CMP_LIGHT1

	ANDIM	FLAG_OCCUPIED,	1110B	;释放对通道0最终结果的锁定

	BC	ERROR_LIGHT		;光源故障

	ANDIM	ALARM_STATE,	1101B	;清除光源故障标志位
	JMP     PROCESS_LIGHT_END

ERROR_LIGHT:
	ORIM	ALARM_STATE,	0010B	;置光源故障标志位
	
	ADI	SELF_STATE,	1000B	;判断当前是否处于手动自检状态
	BA3	PROCESS_LIGHT_END
	ORIM	BEEP_CTL,	0001B	;如果手动自检状态下发生光源故障，则蜂鸣器应每50秒蜂鸣2秒

PROCESS_LIGHT_END:
	RTNI

;***********************************************************
;光源状态检测，并置相应标志位
;***********************************************************
LIGHT_STATE_CHK:

	LDI	TBR,		0101B	;将立即数0101B载入累加器A中
	AND	LIGHT_TYPE		;BIT0\2为1，代表灯具为常亮型

	BNZ	TYPE_ON			;为常亮型灯具
	JMP	TYPE_OFF		;为常灭型灯具
	
TYPE_ON:
	CALL	PROCESS_LIGHT		;检测光源，并设置相应标志位
	JMP     LIGHT_STATE_CHK_END

TYPE_OFF:
	ADI	SYSTEM_STATE,	01H	;检查主电源供电是否正常
	BA0	LIGHT_STATE_CHK_END	;处于主电源正常供电状态，无需对光源进行检测
	CALL	PROCESS_LIGHT		;检测光源，并设置相应标志位

LIGHT_STATE_CHK_END:
	RTNI


;***********************************************************
;LED与蜂鸣器控制
;充电回路无故障的前提下，红色LED:未充电时关闭红灯，在充电时打开红灯
;充电回路开路/短路: 红灯灭，黄灯1HZ闪烁
;光源开路/短路:             黄灯3HZ闪烁
;放电时间不足:              黄灯常亮
;并根据模式标志位，控制蜂鸣器
;***********************************************************
TIPS_PROCESS:
;红灯的处理
RED:
	LDA	ALARM_STATE 		;判断电池充电回路是否处于故障状态
	BA0	RED_ERROR		;电池有故障，则跳转

	LDA	ALREADY_ENTER		;电池充电回路没有故障，
	BA0	RED_ON
	
RED_ERROR:	
	ANDIM	PORTC,		1110B	;关闭红灯
	JMP	GREEN

RED_ON:
	ORIM	PORTC,		0001B	;打开红灯	

;--------------------------------------------------------------------------
;绿灯的处理
GREEN:
	LDA	GREEN_FLASH
	BA1	GREEN_1HZ
	BA2	GREEN_3HZ

	LDA	SYSTEM_STATE
	BNZ	GREEN_OFF		;如果当前系统为应急状态，则绿灯灭
	ORIM	PORTC,		0010B	;如果当前系统主电源正常，则绿灯亮
	JMP	ALARM_BAT

GREEN_OFF:
	ANDIM	PORTC,		1101B	;熄灭绿灯
	JMP	ALARM_BAT

GREEN_1HZ:	
	ADI	F_168MS,	01H	;判断是否到了一个新168MS
	BA0 	BEEP_PROCESS		;还没有到168MS，直接跳至结束;;;;
	
	ADIM	CNT_LED_GREEN,	01H
	SBI	CNT_LED_GREEN,	03H

	BNC	ALARM_BAT
	LDI	CNT_LED_GREEN,	00H
	EORIM	PORTC,		0010B
	JMP	ALARM_BAT

GREEN_3HZ:	
	ADI	F_168MS,	01H	;判断是否到了一个新168MS
	BA0 	BEEP_PROCESS		;;;
	EORIM	PORTC,		0010B
	
;--------------------------------------------------------------------------
;电池充电回路故障处理
ALARM_BAT:	
	LDI	TBR,		0001B	;将0001B载入累加器A中
	AND	ALARM_STATE 		;判断电池是否处于故障状态
	BAZ	ALARM_LIGHT		;电池没有故障，则跳转

	ADI	F_168MS,	01H	;判断是否到了一个新168MS
	BA0	ALARM_TIME_NOT_ENOUGH	;还未到新的168MS,跳转

	ADIM	CNT_LED_YELLOW,	01H	;168MS已到，计数器加1

	SBI	CNT_LED_YELLOW,	03H
	BNC	ALARM_LIGHT		;未满500ms

	LDI	CNT_LED_YELLOW,	00H	;清零计数器
	EORIM	PORTE,		0001B	;以1HZ频率翻转黄灯

;--------------------------------------------------------------------------
;光源故障的处理
ALARM_LIGHT:
	LDI	TBR,		0010B	;将0010B载入累加器A中
	AND	ALARM_STATE		;判断光源是否处于故障状态
	BAZ	ALARM_TIME_NOT_ENOUGH	;光源没有故障，则跳转

	ADI	CNT0_168MS,	01H	;判断是否到了一个新168MS
	BA0	ALARM_TIME_NOT_ENOUGH	;还未到新的168MS,跳转

	EORIM	PORTE,		0001B	;以3HZ频率翻转黄灯

;--------------------------------------------------------------------------
;应急时长不足的处理
ALARM_TIME_NOT_ENOUGH:
	LDI	TBR,		0100B	;将0100B载入累加器A中
	AND	ALARM_STATE		;判断是否出现放电时间不足之故障
	BAZ	OFF_LED_YELLOW		;没有出现放电时间不足之故障，则跳转
	
	ORIM	PORTE,		0001B	;黄灯长亮
	JMP	BEEP_PROCESS		;;;

OFF_LED_YELLOW:
	LDA	ALARM_STATE		;如果没有任何故障，则关闭黄灯
	BNZ	BEEP_PROCESS		;;;
	ANDIM	PORTE,		1110B

;--------------------------------------------------------------------------
;蜂鸣器的处理
BEEP_PROCESS:
	LDA	ALARM_STATE
	BNZ	THERE_ARE_ALARM		;如果有电池、光源或是放电时长不足的故障，则跳转

	JMP	BEEP_OFF		;如果没有故障，则跳转

THERE_ARE_ALARM:
	LDA	BEEP_CTL
	BA0	BEEP_ON_GOING		;如果当前蜂鸣器应提示故障，则跳转
	JMP	BEEP_OFF		;如果当前没有故障需由蜂鸣器做出提示，则跳转
	
BEEP_ON_GOING:
	LDA	ALREADY_BEEP	
	BA0	CHK_2S_OR_50S		;如果不是第一次进入，则跳转

	ORIM	TCTL1,		1000B	;使能Timer1
	ORIM	ALREADY_BEEP,	0001B	;置已经使能Timer1标志位
	LDI	CNT_2S,		00H	;从0开始2秒计时
	ANDIM	BEEP_CTL,	0111B	;转入2秒计时

CHK_2S_OR_50S:
	LDA	BEEP_CTL
	BA3	BEEP_CHK_50S		;如果当前正在对50进行计时，则跳转

BEEP_CHK_2S:
	ADI	BEEP_CTL,	01H	;判断2秒是否已经到了
	BA1	TIPS_PROCESS_END

	ANDIM	BEEP_CTL,	1101B	;清2秒到标志
	ANDIM	TCTL1,		0111B	;如果2秒已经到了，则应禁能Timer1，让蜂鸣器停止蜂鸣，由2秒计时转入计时50秒

	LDI	CNT0_50S,	01H	;重置50秒计数器
	LDI	CNT1_50S,	03H

	ORIM	BEEP_CTL,	1000B	;转入50秒计时
	JMP	TIPS_PROCESS_END
	
BEEP_CHK_50S:
	ADI	BEEP_CTL,	0100B	;判断50秒计时是事已经到了
	BA2	TIPS_PROCESS_END

	ANDIM	BEEP_CTL,	1011B	;清50秒到标志
	ORIM	TCTL1,		1000B	;让蜂鸣器开始蜂鸣

	LDI	CNT_2S,		00H	;重置2秒计数器

	ANDIM	BEEP_CTL,	0111B	;转入2秒计时
	JMP	TIPS_PROCESS_END

BEEP_OFF:
	ANDIM	TCTL1,		0111B	;让蜂鸣器停止蜂鸣

	LDI	BEEP_CTL,	00H
	LDI	ALREADY_BEEP,	00H	;清除已进入蜂鸣标志
	LDI	CNT_2S,		00H	;重置2秒计数器
	LDI	CNT0_50S,	01H	;重置50秒计数器
	LDI	CNT1_50S,	03H

TIPS_PROCESS_END:
	ANDIM	F_168MS,	1110B	;清除168MS标志
	RTNI



;***********************************************************
;按键扫描
;输入: 
;-- F_168MS.1		168ms标志
;-- PORTD.0		按键状态，1为未按下，0表示按键被按下
;输出: 		
;-- BTN_PRE_STA		上一次按键扫描时的按键状态
;-- PRESS_DURATION		本次按键按下的时长，位图形式表示
;局部变量:
;-- TEMP	
;-- BTN_PRESS_CNT		本次按键按下的时长，单位为多少个168ms
;***********************************************************
KEY_PROCESS:

	LDI 	PDCR,		1110B 	;设置PD.0 为输入，PD.3 为输出
	
KEY_CHECK:
	ADI	F_168MS,	0010B	;检查168MS标志位
	BA1	KEY_PROCESS_END		;未到168ms，暂时不做按键扫描

	ANDIM	F_168MS,	1101B	;清168MS标志位
	;CALL 	DELAY_5MS 		;消除按键抖动
	
	LDA 	PORTD,		00H 	;读取PD 口状态
	STA 	TEMP,		00H 	;把PD 口状态存到TEMP 寄存器中
	CALL 	DELAY_5MS 		;消除按键抖动
	
	;LDA 	PORTD,		00H 	;读取PD 口状态
	;SUB 	TEMP,		00H 	;比较读取PD.0 口状态值，不相等则错误
	;BA0 	KEY_ERROR
	;CALL 	DELAY_5MS 		;消除按键抖动
	
	LDA 	PORTD,		00H 	;读取PD 口状态
	SUB 	TEMP,		00H 	;比较读取PD.0 口状态值，不相等则错误
	BA0 	KEY_ERROR
	
	LDA 	TEMP		 	;将TEMP 中的数据储存至累加器A 中
	BA0	NO_KEY_PRESSED		;没有检测到按键
	
	JMP	KEY_PRESSED		;检测到按键被按下

NO_KEY_PRESSED:
	LDA	BTN_PRE_STA		;将上一次按键状态载入累加器A 中
	ADD	TEMP			;TEMP + A -> A
	BA0	KEY_RELEASED		;上一次按下，本次未按下

	JMP 	ALWAYS_NO_KEY		;上一次未按下，本次也未按下

KEY_RELEASED:
	LDI	BTN_PRESS_CNT0,	00H
	LDI	BTN_PRESS_CNT1,	00H
	JMP	KEY_CHECK_PROCESS_OVER

KEY_PRESSED:	
	SBI	BTN_PRESS_CNT0, 0AH	;比较BTN_PRESS_CNT 与 0x2A 的大小
	LDI	TBR,		02H
	SBC	BTN_PRESS_CNT1
	BC	KEY_CHECK_PROCESS_OVER	;如果BTN_PRESS_CNT已经累加至0x2A，则不再累加

	ADIM	BTN_PRESS_CNT0,	01H	;168MS计时次数加1
	LDI	TBR,		00H
	ADCM	BTN_PRESS_CNT1

KEY_PRESSED_DURATION_CHK:
	SBI	BTN_PRESS_CNT0,	02H	;
	LDI	TBR,		01H
	SBC	BTN_PRESS_CNT1
	BNC	KPC_LESS_3S		;按键持续时长小于3S, 18 * 168ms = 3s

	SBI	BTN_PRESS_CNT0,	0EH	;
	LDI	TBR,		01H
	SBC	BTN_PRESS_CNT1
	BNC	KPC_LESS_5S		;按键持续时长小于5S, 30 * 168ms = 5s

	SBI	BTN_PRESS_CNT0,	0AH	;
	LDI	TBR,		02H
	SBC	BTN_PRESS_CNT1
	BNC	KPC_LESS_7S		;按键持续时长小于7S, 42 * 168ms = 7s

KPC_MORE_7S:
	LDI	PRESS_DURATION,	1000B	;置"大于7秒"状态
	JMP	KEY_CHECK_PROCESS_OVER	
KPC_LESS_3S:
	LDI	PRESS_DURATION,	0001B	;置"小于3秒"状态
	JMP	KEY_CHECK_PROCESS_OVER
KPC_LESS_5S:
	LDI	PRESS_DURATION,	0010B	;置"大于3秒，小于5秒"状态
	JMP	KEY_CHECK_PROCESS_OVER
KPC_LESS_7S:
	LDI	PRESS_DURATION,	0100B	;置"大于5秒，小于7秒"状态
	JMP	KEY_CHECK_PROCESS_OVER

ALWAYS_NO_KEY:
	LDI	PRESS_DURATION,	00H
KEY_ERROR: 				;错误键值处理
;ON_RELEASED:
	LDI	BTN_PRESS_CNT0,	00H
	LDI	BTN_PRESS_CNT1,	00H
	
KEY_CHECK_PROCESS_OVER: 		;按键扫描及处理结束，返回
	ANDIM	TEMP,		0001B	;
	STA	BTN_PRE_STA		;TEMP -> BTN_PRE_STA
	
KEY_PROCESS_END:
	RTNI

	


;***********************************************************
;设置自检标志位
;输入
;-- F_TIME		系统时间的月、年标志位
;-- BTN_PRE_STA		当前按键状态
;-- PRESS_DURATION		按键被按下所持续时长，位图形式表示
;输出
;-- SELF_STATE		自检标志
;-- GREEN_FLASH		绿灯闪烁标志位
;
;***********************************************************
SELF_CHK_STATE:
	LDA	SYSTEM_STATE
	BA0	SELF_CHK_STATE_END	;当前处于停电状态，不作自检标志位检查

	LDA	F_TIME
	BA2	SET_YEAR_BIT		;如果1年时间已到，则跳转
	BA1	SET_MONTH_BIT		;如果1月时间已到，则跳转

;--------------------------------------------------------------------------------------

MANUAL_CHK:
	LDA	BTN_PRE_STA		;载入当前按键状态
	BA0	SCT_BTN_RELEASED	;如果当前没有按键被按下，则跳转

	LDI	TBR,		0110B
	AND	SELF_STATE
	BAZ	SCT_SET_EMEG		;如果按键被按下，并且系统未进入月检或是年检状态，则跳转

	LDI	SELF_STATE,	00H	;如果按键被按下，并且系统处于月检可是年检状态，则退出
	LDI	GREEN_FLASH,	00H	;月检或是年检状态，停止绿灯的闪烁
	JMP	SELF_CHK_STATE_END

SCT_SET_EMEG:
	LDI	SELF_STATE,	1001B	;置模拟应急标志位

SCT_BTN_RELEASED:
	LDA	PRESS_DURATION	
	BAZ	SELF_CHK_STATE_END	;如果没有按键，则跳转
	
	BA0	SCS_LESS_3S		;如果持续按键时长小于3秒，则跳转
	BA1	SCS_LESS_5S		;如果持续按键时长大于3秒，小于5秒，则跳转
	BA2	SCS_LESS_7S		;如果持续按键时长大于5秒，小于7秒，则跳转
	BA3	SCS_LESS_7S		;如果持续按键时长大于7秒，则跳转
	
;--------------------------------------------------------------------------------------

SCS_LESS_3S:
	LDI	GREEN_FLASH,	00H	;让绿灯停止闪烁

	ADI	BTN_PRE_STA,	01H
	BA0	SELF_CHK_STATE_END	;如果当前按键为按下状态，则跳转
	
	LDI	SELF_STATE,	00H	;退出月检、年检、模拟停电、手动月检、手动年检状态
	JMP	SELF_CHK_STATE_END

;--------------------------------------------------------------------------------------

SCS_LESS_5S:
	LDI	GREEN_FLASH,	0010B	;让绿灯以1HZ的频率开始闪烁

	ADI	BTN_PRE_STA,	01H
	BA0	SELF_CHK_STATE_END	;如果当前按键为按下状态，则跳转
	
	LDI	SELF_STATE,	1010B	;置手动月检标志位
	JMP	SELF_CHK_STATE_END

;--------------------------------------------------------------------------------------

SCS_LESS_7S:
	LDI	GREEN_FLASH,	0100B	;让绿灯以3HZ的频率开始闪烁
	
	ADI	BTN_PRE_STA,	01H
	BA0	SELF_CHK_STATE_END	;如果当前按键为按下状态，则跳转
	
	LDI	SELF_STATE,	1100B	;置手动年检标志位
	JMP	SELF_CHK_STATE_END

;--------------------------------------------------------------------------------------	

SET_MONTH_BIT:
	ANDIM	F_TIME,		1101B	;清1月到标志位
	LDI	SELF_STATE,	0010B	;置自动月检标志位
	JMP	SELF_CHK_STATE_END

;--------------------------------------------------------------------------------------	

SET_YEAR_BIT:
	ANDIM	F_TIME,		1011B	;清1年到标志位
	LDI	SELF_STATE,	0100B	;置自动年检标志位
	JMP	SELF_CHK_STATE_END

;--------------------------------------------------------------------------------------	

SELF_CHK_STATE_END:
	RTNI


;***********************************************************
;在月检、年检、模拟停电、手动月检、手动年检时，打开应急
;1. PE.1继电器输出低电平
;2. 延时20ms
;3. 使能PWM0
;***********************************************************
EN_PWM0_DLY_20MS:

	ANDIM	PORTE,		1101B	;PE.1输出低电平

	CALL	DELAY_5MS		;延时20ms
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS

	ORIM	PWMC0,		0001B	;使能PWM0输出

EN_PWM0_DLY_20MS_END:
	RTNI


;***********************************************************
;在月检、年检、模拟停电、手动月检、手动年检时，关闭应急
;1. 禁能PWM0
;2. 延时20ms
;3. PE.1继电器恢复输出高电平
;***********************************************************
DIS_PWM0_DLY_20MS:

	ANDIM	PWMC0,		1110B	;关闭PWM0输出

	CALL	DELAY_5MS		;延时20ms
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS

	ORIM	PORTE,		0010B	;PE.1输出高电平

DIS_PWM0_DLY_20MS_END:
	RTNI
	

;***********************************************************
;根据自检标志位，进行自检
;输入
;-- SELF_STATE		当前系统自检状态
;--
;输出
;-- DURATION_EMER		应急持续时长，位图形式表示
;-- ALARM_STATE.0		应急时长不足故障标志位
;-- CNT0/1/2_EMERGENCY	应急持续时长，单位秒
;-- ALREADY_ENTER.2/3	在月检或年检状态下，已经使能应急功能
;***********************************************************
SELF_CHK_PROCESS:

	LDA	SYSTEM_STATE
	BA0	SELF_CHK_PROCESS_END	;如果停电，则跳转

	LDA	SELF_STATE		;检查自检状态标志
	BA0	SCP_EMERGENCY		;如果模拟停电标志位为1，则跳转

	LDA	SELF_STATE
	BA1	SCP_MONTH		;如果手动月检标志为1，则跳转

	;ADI	ALREADY_ENTER,	0100B	
	;BA2	SCP_CHK_YEAR_BIT	;如果上一次不是月检，则跳转
	;JMP	SCP_ARRIVE_120S		;如果上一次月检标志为1，本次为0，则退出月检	

;SCP_CHK_YEAR_BIT:
	LDA	SELF_STATE
	BA2	SCP_YEAR		;如果手动年检标志为1，则跳转

	;ADI	ALREADY_ENTER,	1000B	
	;BA3	SCP_CLEAR_ALL		;如果上一次不是年检，则跳转
	;JMP	SCP_ARRIVE_30MIN	;如果上一次年检标志为1，本次为0，则退出年检

SCP_CLEAR_ALL:
	JMP	SCP_DIS_EMERGENCY	;如果自检标志均为0，则关闭应急
	
;---------------------------------------------------------------------------

SCP_EMERGENCY:
	CALL	EN_PWM0_DLY_20MS	;使能PWM0输出
	JMP	SELF_CHK_PROCESS_END

;---------------------------------------------------------------------------

SCP_DIS_EMERGENCY:
	CALL	DIS_PWM0_DLY_20MS	;关闭PWM0输出
	JMP	SELF_CHK_PROCESS_END

;---------------------------------------------------------------------------

SCP_MONTH:
	LDA	ALREADY_ENTER
	BA2	SCP_MONTH_1S		;如果已经打开应急，则跳转

	ORIM	ALREADY_ENTER,	0100B	;置已经进入手动月检标志位
	LDI	CNT0_EMERGENCY,	00H	;应急时长清零
	LDI	CNT1_EMERGENCY,	00H
	LDI	CNT2_EMERGENCY,	00H
	CALL	EN_PWM0_DLY_20MS	;使能PWM0输出
	JMP	SELF_CHK_PROCESS_END
	
;---------------------------------------------------------------------------

SCP_MONTH_1S:
	ADI	F_1S,		0001B
	BA0	SELF_CHK_PROCESS_END	;还未到1秒，则跳转

	ANDIM	F_1S,		1110B	;清供应急计时用的1秒标志位

	SBI	CNT0_EMERGENCY,	08H	;和120秒比较(0x78)
	LDI	TBR,		07H
	SBC	CNT1_EMERGENCY

	BC	SCP_ARRIVE_120S		;如果应急时长超过120秒，则跳转

	ADIM	CNT0_EMERGENCY,	01H	;应急时长加1
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY

	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDA	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDA	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

	BNC	SELF_CHK_PROCESS_END	;如果电池还未耗尽，则跳转

	ORIM	ALARM_STATE,	0100B	;置放电时长不足标志位

	ADI	SELF_STATE,	1000B
	BA3	SCP_ARRIVE_120S

	ORIM	BEEP_CTL,	0001B	;如果在手动月检状态下，检测到放电时长不足120秒，则蜂鸣器应每50秒蜂鸣2秒
	
;---------------------------------------------------------------------------

SCP_ARRIVE_120S:
	CALL	DIS_PWM0_DLY_20MS	;关闭PWM0输出
	LDI	SELF_STATE,	0000B	;清月检标志位
	ANDIM	GREEN_FLASH,	1101B	;让绿灯停止以1HZ的频率闪烁	
	ANDIM	ALREADY_ENTER,	1011B	;清在手动月检状态下已经开始应急的标志位

	ORIM	DURATION_EMER,	0001B	;应急时长为2分钟，置应急时长小于5分钟标志位
	CALL	RE_CALC_TIME		;根据应急时长，重新计算待充电时长
	JMP	SELF_CHK_PROCESS_END
	
;---------------------------------------------------------------------------

SCP_YEAR:
	LDA	ALREADY_ENTER
	BA3	SCP_YEAR_1S		;如果已经打开应急，则跳转

	ORIM	ALREADY_ENTER,	1000B	;置已经进入应急标志位
	LDI	CNT0_EMERGENCY,	00H	;应急时长清零
	LDI	CNT1_EMERGENCY,	00H
	LDI	CNT2_EMERGENCY,	00H
	CALL	EN_PWM0_DLY_20MS	;使能PWM0输出
	JMP	SELF_CHK_PROCESS_END

SCP_YEAR_1S:
	ADI	F_1S,		0001B
	BA0	SELF_CHK_PROCESS_END	;还未到1秒，则跳转

	ANDIM	F_1S,		1110B	;清供应急计时用的1秒标志位

	ADIM	CNT0_EMERGENCY,	01H	;应急时长加1
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY
	
	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDA	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDA	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

	BNC	SELF_CHK_PROCESS_END	;如果电池还未耗尽，则跳转

	SBI	CNT0_EMERGENCY,	08H	;和30分钟比较(0x708)
	LDI	TBR,		00H
	SBC	CNT1_EMERGENCY
	LDI	TBR,		07H
	SBC	CNT2_EMERGENCY	

	BC	SCP_ARRIVE_30MIN

	ORIM	ALARM_STATE,	0100B	;置应急放电时长不足标志位

	ADI	SELF_STATE,	1000B
	BA3	SCP_ARRIVE_30MIN

	ORIM	BEEP_CTL,	0001B	;如果在手动年检状态下，检测到放电时长不足30分钟，则蜂鸣器应每50秒蜂鸣2秒

	
;---------------------------------------------------------------------------

SCP_ARRIVE_30MIN:
	CALL	DIS_PWM0_DLY_20MS	;关闭PWM0输出
	LDI	SELF_STATE,	0000B	;清年检标志位
	ANDIM	GREEN_FLASH,	1011B	;让绿灯停止以3HZ的频率闪烁
	ANDIM	ALREADY_ENTER,	0111B	;清已经进入手动年检标志位	

	SBI	CNT0_EMERGENCY,	0CH	;和5分钟比较(0x12C)
	LDI	TBR,		02H
	SBC	CNT1_EMERGENCY
	LDI	TBR,		01H
	SBC	CNT2_EMERGENCY

	BNC	YEAR_LESS_5_MINUTE	;应急时长小于5分钟

	SBI	CNT0_EMERGENCY,	08H	;和30分钟比较(0x708)
	LDI	TBR,		00H
	SBC	CNT1_EMERGENCY
	LDI	TBR,		07H
	SBC	CNT2_EMERGENCY

	BNC	YEAR_LESS_30_MINUTE	;应急时长小于30分钟

YEAR_MORE_30_MINUTE:			;应急时长大于30分钟
	ORIM	DURATION_EMER,	0100B
	CALL	RE_CALC_TIME		;发生了应急放电事件，重新计算待充电时长
	JMP	SELF_CHK_PROCESS_END

YEAR_LESS_5_MINUTE:
	ORIM	DURATION_EMER,	0001B
	CALL	RE_CALC_TIME		;发生了应急放电事件，重新计算待充电时长
	JMP	SELF_CHK_PROCESS_END
	
YEAR_LESS_30_MINUTE:
	ORIM	DURATION_EMER,	0010B
	CALL	RE_CALC_TIME		;发生了应急放电事件，重新计算待充电时长
	JMP	SELF_CHK_PROCESS_END
	
;---------------------------------------------------------------------------
	
SELF_CHK_PROCESS_END:
	RTNI



;************************************************************
; 延时5 毫秒子程序
;************************************************************
DELAY_5MS:
	LDI 	DELAY_TIMER2,	03H 	;设置初始值
	LDI 	DELAY_TIMER1,	03H
	LDI 	DELAY_TIMER0,	0CH

DELAY_5MS_LOOP:
	SBIM 	DELAY_TIMER0,	01H 	;每次减1
	LDI 	CLEAR_AC,	00H
	SBCM 	DELAY_TIMER1,	00H
	LDI 	CLEAR_AC,	00H
	SBCM 	DELAY_TIMER2,	00H
	BC 	DELAY_5MS_LOOP
	
	RTNI


;*******************************************
; 子程序: CAL_CHN0_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN0_ADCDATA:
	ADI	FLAG_OCCUPIED,		0001B
	BA0	CAL_CHN0_AD_MIN01
	JMP	CAL_CHN0_ADCDATA_END		;正在使用转换结果

;----------------------------
;寻找最小值
CAL_CHN0_AD_MIN01:	
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK1,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK1,		01H
	BC 	CAL_CHN0_AD_MIN02 		;D0<D1	

CAL_CHN0_AD_MIN12:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MIN13 		;D1<D2

CAL_CHN0_AD_MIN23:
	LDA 	CHN0_RET1_BAK2,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK2,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN0_AD_MIN3

CAL_CHN0_AD_MIN13:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN0_AD_MIN3

;D0<D1
CAL_CHN0_AD_MIN02:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN0_AD_MIN23

;D0<D2
CAL_CHN0_AD_MIN03:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN0_AD_MIN3

;-----------------------
;将最小值清零
CAL_CHN0_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK0,		01H
	STA 	CHN0_RET1_BAK0,		01H
	STA 	CHN0_RET2_BAK0,		01H
	JMP 	CAL_CHN0_AD_MAX01

CAL_CHN0_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK1,		01H
	STA 	CHN0_RET1_BAK1,		01H
	STA 	CHN0_RET2_BAK1,		01H
	JMP 	CAL_CHN0_AD_MAX01

CAL_CHN0_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK2,		01H
	STA 	CHN0_RET1_BAK2,		01H
	STA 	CHN0_RET2_BAK2,		01H
	JMP 	CAL_CHN0_AD_MAX01

CAL_CHN0_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK3,		01H
	STA 	CHN0_RET1_BAK3,		01H
	STA 	CHN0_RET2_BAK3,		01H
	JMP 	CAL_CHN0_AD_MAX01

;----------------------------
;寻找最大值
CAL_CHN0_AD_MAX01:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK1,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK1,		01H
	BC 	CAL_CHN0_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN0_AD_MAX02:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN0_AD_MAX03:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN0_AD_MAX0

;D2>D0
CAL_CHN0_AD_MAX23:
	LDA 	CHN0_RET1_BAK2,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK2,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN0_AD_MAX2

;D1>D0
CAL_CHN0_AD_MAX12:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN0_AD_MAX13:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN0_AD_MAX1

;-----------------------
;将最大值清零
CAL_CHN0_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK0,		01H
	STA 	CHN0_RET1_BAK0,		01H
	STA 	CHN0_RET2_BAK0,		01H
	JMP 	CAL_CHN0_AD_ADD

CAL_CHN0_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK1,		01H
	STA 	CHN0_RET1_BAK1,		01H
	STA 	CHN0_RET2_BAK1,		01H
	JMP 	CAL_CHN0_AD_ADD

CAL_CHN0_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK2,		01H
	STA 	CHN0_RET1_BAK2,		01H
	STA 	CHN0_RET2_BAK2,		01H
	JMP 	CAL_CHN0_AD_ADD

CAL_CHN0_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK3,		01H
	STA 	CHN0_RET1_BAK3,		01H
	STA 	CHN0_RET2_BAK3,		01H
	JMP 	CAL_CHN0_AD_ADD

;----------------------------
;计算总和并存放在CHN0_RET0_BAK3,CHN0_RET1_BAK3 和CHN0_RET2_BAK3（包括两个被清零的）
CAL_CHN0_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN0_RET0_BAK0,		01H
	;ADDM 	CHN0_RET0_BAK1,		01H
	LDA 	CHN0_RET1_BAK0,		01H
	ADDM 	CHN0_RET1_BAK1,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	ADCM 	CHN0_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN0_RET0_BAK1,		01H
	;ADDM 	CHN0_RET0_BAK2,		01H
	LDA 	CHN0_RET1_BAK1,		01H
	ADDM 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	ADCM 	CHN0_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN0_RET0_BAK2,		01H
	;ADDM 	CHN0_RET0_BAK3,		01H
	LDA 	CHN0_RET1_BAK2,		01H
	ADDM 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK2,		01H
	ADCM 	CHN0_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;总和除以2，得到平均值，存放在CHN0_FINAL_RET0(),CHN0_FINAL_RET1 和CHN0_FINAL_RET2
CAL_CHN0_AD_DIV:
	;LDA 	CHN0_RET0_BAK3,		01H
	;SHR
	;STA 	CHN0_RET0_BAK3,		01H
	
	LDA 	CHN0_RET1_BAK3,		01H
	SHR
	STA 	CHN0_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN0_RET0_BAK3

	LDA 	CHN0_RET2_BAK3,		01H
	SHR
	STA 	CHN0_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN0_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN0_RET2_BAK3,		01H


	;LDA	CHN0_RET0_BAK3,		01H
	;STA	CHN0_FINAL_RET0,		01H
	LDA	CHN0_RET1_BAK3,		01H
	STA	CHN0_FINAL_RET1,	01H
	LDA	CHN0_RET2_BAK3,		01H
	STA	CHN0_FINAL_RET2,	01H

;----------------------------
;调整为CHN0_FINAL_RET0存放低4位，CHN0_FINAL_RET1存放中4位，CHN0_FINAL_RET2存放高2位
	;LDA 	CHN0_FINAL_RET1,		01H
	;SHR
	;STA 	CHN0_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN0_FINAL_RET0,		01H

	;LDA 	CHN0_FINAL_RET1,		01H
	;SHR
	;STA 	CHN0_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN0_FINAL_RET0,		01H


	;LDA 	CHN0_FINAL_RET2,		01H
	;SHR
	;STA 	CHN0_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN0_FINAL_RET1,		01H

	;LDA 	CHN0_FINAL_RET2,		01H
	;SHR
	;STA 	CHN0_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN0_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN0_ADCDATA_END:	

	RTNI

;*******************************************
; 子程序: CAL_CHN1_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN1_ADCDATA:
	ADI	FLAG_OCCUPIED,		0010B
	BA1	CAL_CHN1_AD_MIN01
	JMP	CAL_CHN1_ADCDATA_END		;正在使用转换结果

;----------------------------
;寻找最小值
CAL_CHN1_AD_MIN01:	
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK1,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK1,		01H
	BC 	CAL_CHN1_AD_MIN02 		;D0<D1	

CAL_CHN1_AD_MIN12:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MIN13 		;D1<D2

CAL_CHN1_AD_MIN23:
	LDA 	CHN1_RET1_BAK2,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK2,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN1_AD_MIN3

CAL_CHN1_AD_MIN13:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN1_AD_MIN3

;D0<D1
CAL_CHN1_AD_MIN02:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN1_AD_MIN23

;D0<D2
CAL_CHN1_AD_MIN03:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN1_AD_MIN3

;-----------------------
;将最小值清零
CAL_CHN1_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK0,		01H
	STA 	CHN1_RET1_BAK0,		01H
	STA 	CHN1_RET2_BAK0,		01H
	JMP 	CAL_CHN1_AD_MAX01

CAL_CHN1_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK1,		01H
	STA 	CHN1_RET1_BAK1,		01H
	STA 	CHN1_RET2_BAK1,		01H
	JMP 	CAL_CHN1_AD_MAX01

CAL_CHN1_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK2,		01H
	STA 	CHN1_RET1_BAK2,		01H
	STA 	CHN1_RET2_BAK2,		01H
	JMP 	CAL_CHN1_AD_MAX01

CAL_CHN1_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK3,		01H
	STA 	CHN1_RET1_BAK3,		01H
	STA 	CHN1_RET2_BAK3,		01H
	JMP 	CAL_CHN1_AD_MAX01

;----------------------------
;寻找最大值
CAL_CHN1_AD_MAX01:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK1,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK1,		01H
	BC 	CAL_CHN1_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN1_AD_MAX02:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN1_AD_MAX03:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN1_AD_MAX0

;D2>D0
CAL_CHN1_AD_MAX23:
	LDA 	CHN1_RET1_BAK2,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK2,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN1_AD_MAX2

;D1>D0
CAL_CHN1_AD_MAX12:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN1_AD_MAX13:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN1_AD_MAX1

;-----------------------
;将最大值清零
CAL_CHN1_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK0,		01H
	STA 	CHN1_RET1_BAK0,		01H
	STA 	CHN1_RET2_BAK0,		01H
	JMP 	CAL_CHN1_AD_ADD

CAL_CHN1_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK1,		01H
	STA 	CHN1_RET1_BAK1,		01H
	STA 	CHN1_RET2_BAK1,		01H
	JMP 	CAL_CHN1_AD_ADD

CAL_CHN1_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK2,		01H
	STA 	CHN1_RET1_BAK2,		01H
	STA 	CHN1_RET2_BAK2,		01H
	JMP 	CAL_CHN1_AD_ADD

CAL_CHN1_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK3,		01H
	STA 	CHN1_RET1_BAK3,		01H
	STA 	CHN1_RET2_BAK3,		01H
	JMP 	CAL_CHN1_AD_ADD

;----------------------------
;计算总和并存放在CHN1_RET0_BAK3,CHN1_RET1_BAK3 和CHN1_RET2_BAK3（包括两个被清零的）
CAL_CHN1_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN1_RET0_BAK0,		01H
	;ADDM 	CHN1_RET0_BAK1,		01H
	LDA 	CHN1_RET1_BAK0,		01H
	ADDM 	CHN1_RET1_BAK1,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	ADCM 	CHN1_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN1_RET0_BAK1,		01H
	;ADDM 	CHN1_RET0_BAK2,		01H
	LDA 	CHN1_RET1_BAK1,		01H
	ADDM 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	ADCM 	CHN1_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN1_RET0_BAK2,		01H
	;ADDM 	CHN1_RET0_BAK3,		01H
	LDA 	CHN1_RET1_BAK2,		01H
	ADDM 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK2,		01H
	ADCM 	CHN1_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;总和除以2，得到平均值，存放在CHN1_FINAL_RET0(),CHN1_FINAL_RET1 和CHN1_FINAL_RET2
CAL_CHN1_AD_DIV:
	;LDA 	CHN1_RET0_BAK3,		01H
	;SHR
	;STA 	CHN1_RET0_BAK3,		01H
	
	LDA 	CHN1_RET1_BAK3,		01H
	SHR
	STA 	CHN1_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN1_RET0_BAK3

	LDA 	CHN1_RET2_BAK3,		01H
	SHR
	STA 	CHN1_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN1_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN1_RET2_BAK3,		01H


	;LDA	CHN1_RET0_BAK3,		01H
	;STA	CHN1_FINAL_RET0,		01H
	LDA	CHN1_RET1_BAK3,		01H
	STA	CHN1_FINAL_RET1,	01H
	LDA	CHN1_RET2_BAK3,		01H
	STA	CHN1_FINAL_RET2,	01H

;----------------------------
;调整为CHN1_FINAL_RET0存放低4位，CHN1_FINAL_RET1存放中4位，CHN1_FINAL_RET2存放高2位
	;LDA 	CHN1_FINAL_RET1,		01H
	;SHR
	;STA 	CHN1_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN1_FINAL_RET0,		01H

	;LDA 	CHN1_FINAL_RET1,		01H
	;SHR
	;STA 	CHN1_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN1_FINAL_RET0,		01H


	;LDA 	CHN1_FINAL_RET2,		01H
	;SHR
	;STA 	CHN1_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN1_FINAL_RET1,		01H

	;LDA 	CHN1_FINAL_RET2,		01H
	;SHR
	;STA 	CHN1_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN1_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN1_ADCDATA_END:	

	RTNI


;*******************************************
; 子程序: CAL_CHN6_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN6_ADCDATA:
	ADI	FLAG_OCCUPIED,		0100B
	BA2	CAL_CHN6_AD_MIN01
	JMP	CAL_CHN6_ADCDATA_END		;正在使用转换结果
	
;----------------------------
;寻找最小值
CAL_CHN6_AD_MIN01:	
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK1,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK1,		01H
	BC 	CAL_CHN6_AD_MIN02 		;D0<D1	

CAL_CHN6_AD_MIN12:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MIN13 		;D1<D2

CAL_CHN6_AD_MIN23:
	LDA 	CHN6_RET1_BAK2,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK2,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN6_AD_MIN3

CAL_CHN6_AD_MIN13:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN6_AD_MIN3

;D0<D1
CAL_CHN6_AD_MIN02:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN6_AD_MIN23

;D0<D2
CAL_CHN6_AD_MIN03:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN6_AD_MIN3

;-----------------------
;将最小值清零
CAL_CHN6_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK0,		01H
	STA 	CHN6_RET1_BAK0,		01H
	STA 	CHN6_RET2_BAK0,		01H
	JMP 	CAL_CHN6_AD_MAX01

CAL_CHN6_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK1,		01H
	STA 	CHN6_RET1_BAK1,		01H
	STA 	CHN6_RET2_BAK1,		01H
	JMP 	CAL_CHN6_AD_MAX01

CAL_CHN6_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK2,		01H
	STA 	CHN6_RET1_BAK2,		01H
	STA 	CHN6_RET2_BAK2,		01H
	JMP 	CAL_CHN6_AD_MAX01

CAL_CHN6_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK3,		01H
	STA 	CHN6_RET1_BAK3,		01H
	STA 	CHN6_RET2_BAK3,		01H
	JMP 	CAL_CHN6_AD_MAX01

;----------------------------
;寻找最大值
CAL_CHN6_AD_MAX01:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK1,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK1,		01H
	BC 	CAL_CHN6_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN6_AD_MAX02:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN6_AD_MAX03:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN6_AD_MAX0

;D2>D0
CAL_CHN6_AD_MAX23:
	LDA 	CHN6_RET1_BAK2,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK2,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN6_AD_MAX2

;D1>D0
CAL_CHN6_AD_MAX12:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN6_AD_MAX13:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN6_AD_MAX1

;-----------------------
;将最大值清零
CAL_CHN6_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK0,		01H
	STA 	CHN6_RET1_BAK0,		01H
	STA 	CHN6_RET2_BAK0,		01H
	JMP 	CAL_CHN6_AD_ADD

CAL_CHN6_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK1,		01H
	STA 	CHN6_RET1_BAK1,		01H
	STA 	CHN6_RET2_BAK1,		01H
	JMP 	CAL_CHN6_AD_ADD

CAL_CHN6_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK2,		01H
	STA 	CHN6_RET1_BAK2,		01H
	STA 	CHN6_RET2_BAK2,		01H
	JMP 	CAL_CHN6_AD_ADD

CAL_CHN6_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK3,		01H
	STA 	CHN6_RET1_BAK3,		01H
	STA 	CHN6_RET2_BAK3,		01H
	JMP 	CAL_CHN6_AD_ADD

;----------------------------
;计算总和并存放在CHN6_RET0_BAK3,CHN6_RET1_BAK3 和CHN6_RET2_BAK3（包括两个被清零的）
CAL_CHN6_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN6_RET0_BAK0,		01H
	;ADDM 	CHN6_RET0_BAK1,		01H
	LDA 	CHN6_RET1_BAK0,		01H
	ADDM 	CHN6_RET1_BAK1,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	ADCM 	CHN6_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN6_RET0_BAK1,		01H
	;ADDM 	CHN6_RET0_BAK2,		01H
	LDA 	CHN6_RET1_BAK1,		01H
	ADDM 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	ADCM 	CHN6_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN6_RET0_BAK2,		01H
	;ADDM 	CHN6_RET0_BAK3,		01H
	LDA 	CHN6_RET1_BAK2,		01H
	ADDM 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK2,		01H
	ADCM 	CHN6_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;总和除以2，得到平均值，存放在CHN6_FINAL_RET0(),CHN6_FINAL_RET1 和CHN6_FINAL_RET2
CAL_CHN6_AD_DIV:
	;LDA 	CHN6_RET0_BAK3,		01H
	;SHR
	;STA 	CHN6_RET0_BAK3,		01H
	
	LDA 	CHN6_RET1_BAK3,		01H
	SHR
	STA 	CHN6_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN6_RET0_BAK3

	LDA 	CHN6_RET2_BAK3,		01H
	SHR
	STA 	CHN6_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN6_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN6_RET2_BAK3,		01H


	;LDA	CHN6_RET0_BAK3,		01H
	;STA	CHN6_FINAL_RET0,		01H
	LDA	CHN6_RET1_BAK3,		01H
	STA	CHN6_FINAL_RET1,	01H
	LDA	CHN6_RET2_BAK3,		01H
	STA	CHN6_FINAL_RET2,	01H

;----------------------------
;调整为CHN6_FINAL_RET0存放低4位，CHN6_FINAL_RET1存放中4位，CHN6_FINAL_RET2存放高2位
	;LDA 	CHN6_FINAL_RET1,		01H
	;SHR
	;STA 	CHN6_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN6_FINAL_RET0,		01H

	;LDA 	CHN6_FINAL_RET1,		01H
	;SHR
	;STA 	CHN6_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN6_FINAL_RET0,		01H


	;LDA 	CHN6_FINAL_RET2,		01H
	;SHR
	;STA 	CHN6_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN6_FINAL_RET1,		01H

	;LDA 	CHN6_FINAL_RET2,		01H
	;SHR
	;STA 	CHN6_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN6_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN6_ADCDATA_END:	

	RTNI


;*******************************************
; 子程序: CAL_CHN7_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN7_ADCDATA:
	ADI	FLAG_OCCUPIED,		1000B
	BA3	CAL_CHN7_AD_MIN01
	JMP	CAL_CHN7_ADCDATA_END		;正在使用转换结果

;----------------------------
;寻找最小值
CAL_CHN7_AD_MIN01:	
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK1,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK1,		01H
	BC 	CAL_CHN7_AD_MIN02 		;D0<D1	

CAL_CHN7_AD_MIN12:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MIN13 		;D1<D2

CAL_CHN7_AD_MIN23:
	LDA 	CHN7_RET1_BAK2,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK2,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN7_AD_MIN3

CAL_CHN7_AD_MIN13:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN7_AD_MIN3

;D0<D1
CAL_CHN7_AD_MIN02:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN7_AD_MIN23

;D0<D2
CAL_CHN7_AD_MIN03:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN7_AD_MIN3

;-----------------------
;将最小值清零
CAL_CHN7_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK0,		01H
	STA 	CHN7_RET1_BAK0,		01H
	STA 	CHN7_RET2_BAK0,		01H
	JMP 	CAL_CHN7_AD_MAX01

CAL_CHN7_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK1,		01H
	STA 	CHN7_RET1_BAK1,		01H
	STA 	CHN7_RET2_BAK1,		01H
	JMP 	CAL_CHN7_AD_MAX01

CAL_CHN7_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK2,		01H
	STA 	CHN7_RET1_BAK2,		01H
	STA 	CHN7_RET2_BAK2,		01H
	JMP 	CAL_CHN7_AD_MAX01

CAL_CHN7_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK3,		01H
	STA 	CHN7_RET1_BAK3,		01H
	STA 	CHN7_RET2_BAK3,		01H
	JMP 	CAL_CHN7_AD_MAX01

;----------------------------
;寻找最大值
CAL_CHN7_AD_MAX01:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK1,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK1,		01H
	BC 	CAL_CHN7_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN7_AD_MAX02:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN7_AD_MAX03:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN7_AD_MAX0

;D2>D0
CAL_CHN7_AD_MAX23:
	LDA 	CHN7_RET1_BAK2,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK2,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN7_AD_MAX2

;D1>D0
CAL_CHN7_AD_MAX12:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN7_AD_MAX13:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN7_AD_MAX1

;-----------------------
;将最大值清零
CAL_CHN7_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK0,		01H
	STA 	CHN7_RET1_BAK0,		01H
	STA 	CHN7_RET2_BAK0,		01H
	JMP 	CAL_CHN7_AD_ADD

CAL_CHN7_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK1,		01H
	STA 	CHN7_RET1_BAK1,		01H
	STA 	CHN7_RET2_BAK1,		01H
	JMP 	CAL_CHN7_AD_ADD

CAL_CHN7_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK2,		01H
	STA 	CHN7_RET1_BAK2,		01H
	STA 	CHN7_RET2_BAK2,		01H
	JMP 	CAL_CHN7_AD_ADD

CAL_CHN7_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK3,		01H
	STA 	CHN7_RET1_BAK3,		01H
	STA 	CHN7_RET2_BAK3,		01H
	JMP 	CAL_CHN7_AD_ADD

;----------------------------
;计算总和并存放在CHN7_RET0_BAK3,CHN7_RET1_BAK3 和CHN7_RET2_BAK3（包括两个被清零的）
CAL_CHN7_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN7_RET0_BAK0,		01H
	;ADDM 	CHN7_RET0_BAK1,		01H
	LDA 	CHN7_RET1_BAK0,		01H
	ADDM 	CHN7_RET1_BAK1,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	ADCM 	CHN7_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN7_RET0_BAK1,		01H
	;ADDM 	CHN7_RET0_BAK2,		01H
	LDA 	CHN7_RET1_BAK1,		01H
	ADDM 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	ADCM 	CHN7_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN7_RET0_BAK2,		01H
	;ADDM 	CHN7_RET0_BAK3,		01H
	LDA 	CHN7_RET1_BAK2,		01H
	ADDM 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK2,		01H
	ADCM 	CHN7_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;总和除以2，得到平均值，存放在CHN7_FINAL_RET0(),CHN7_FINAL_RET1 和CHN7_FINAL_RET2
CAL_CHN7_AD_DIV:
	;LDA 	CHN7_RET0_BAK3,		01H
	;SHR
	;STA 	CHN7_RET0_BAK3,		01H
	
	LDA 	CHN7_RET1_BAK3,		01H
	SHR
	STA 	CHN7_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN7_RET0_BAK3

	LDA 	CHN7_RET2_BAK3,		01H
	SHR
	STA 	CHN7_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN7_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN7_RET2_BAK3,		01H


	;LDA	CHN7_RET0_BAK3,		01H
	;STA	CHN7_FINAL_RET0,		01H
	LDA	CHN7_RET1_BAK3,		01H
	STA	CHN7_FINAL_RET1,	01H
	LDA	CHN7_RET2_BAK3,		01H
	STA	CHN7_FINAL_RET2,	01H

;----------------------------
;调整为CHN7_FINAL_RET0存放低4位，CHN7_FINAL_RET1存放中4位，CHN7_FINAL_RET2存放高2位
	;LDA 	CHN7_FINAL_RET1,		01H
	;SHR
	;STA 	CHN7_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN7_FINAL_RET0,		01H

	;LDA 	CHN7_FINAL_RET1,		01H
	;SHR
	;STA 	CHN7_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN7_FINAL_RET0,		01H


	;LDA 	CHN7_FINAL_RET2,		01H
	;SHR
	;STA 	CHN7_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN7_FINAL_RET1,		01H

	;LDA 	CHN7_FINAL_RET2,		01H
	;SHR
	;STA 	CHN7_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN7_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN7_ADCDATA_END:	

	RTNI

	
	END

	
