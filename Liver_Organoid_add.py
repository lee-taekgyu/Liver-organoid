import sys
import time

with open(sys.argv[1] + '_Tendency.txt', 'w') as tendency:
	with open(sys.argv[1] + '_mean.txt', 'r') as handle:
		for line in handle:
			line1 = line.strip()
			if '\t' in line:
				line = line.strip()
				line = line.replace('\t', ' ')
				line = line.split(' ')
				del line[4]
				Chr = line[0]
				Start = line[1]
				End = line[2]
				CpG_NUM = line[3]
				E = line[4]
				T = line[6]
				L = line[8]
				T_E = float(line[6]) - float(line[4])
				if T_E > 0 :
					T_E = str(T_E) + ';' + '+'
				elif T_E < 0 :
					T_E = str(T_E) + ';' + '-'
				elif T_E == 0 :
					T_E = str(T_E) + ';' + '.'
				T_L = float(line[6]) - float(line[8])
				if T_L > 0 :
					T_L = str(T_L) + ';' + '+'
				elif T_L < 0 :
					T_L = str(T_L) + ';' + '-'
				elif T_L == 0 :
					T_L = str(T_L) + ';' + '.'
				L_E = float(line[8]) - float(line[4])
				if L_E > 0 :
					L_E = str(L_E) + ';' + '+'
				elif L_E < 0 :
					L_E = str(L_E) + ';' + '-'
				elif L_E == 0 :
					L_E = str(L_E) + ';' + '.'
				tendency.write(Chr + '\t' + Start + '\t' + End + '\t' + CpG_NUM + '\t' + E + '\t' + line[5] + '\t' + T + '\t' + line[7] + '\t' + L + '\t' + line[9] + '\t' + str(T_E) + '\t' + str(T_L) + '\t' + str(L_E) + '\n')
        
        
Chromosome = []
for num in range(1,23):
	Chromosome.append('chr' + str(num))
Chromosome.extend(['chrX', 'chrY'])

for chromosome in Chromosome:
	cpg_dic = {}
	with open(sys.argv[1], 'r') as cpg:
		for line in cpg:
			line = line.strip().split('\t')
			Chr = line[0]
			if Chr == chromosome:
				Start = line[1]
				End = line[2]
				rest = line[3:]
				rest = ','.join(rest)
				rest = rest.replace(',', '\t')
				cpg_dic[Start + ' ' + End + ' ' + rest] = Chr

	pos_dic = {}
	with open(sys.argv[2], 'r') as gtf:
		for line in gtf:
			if line.startswith('##'):
				continue
			line = line.strip().split('\t')
			Chr = line[0]
			if Chr == chromosome:
				Region = line[2]
				if Region == 'transcript':
					Start = line[3]
					End = line[4]
					Description = line[8].split(';')[3]
					Gene_name = Description.split('"')[1]
					pos_dic[Start + ' ' + End] = Gene_name


	check = []
	with open(sys.argv[1].split('_')[0] + '_Gene.txt', 'a') as annotation:
		for pos_key in pos_dic.keys():
			for cpg_key in cpg_dic.keys():
				if int(cpg_key.split(' ')[0]) >= int(pos_key.split(' ')[0]) and int(cpg_key.split(' ')[1]) <= int(pos_key.split(' ')[1]):
					if pos_dic[pos_key] in check:
						pass
					else:
						annotation.write(chromosome + '\t' + cpg_key.split(' ')[0] + '\t' + cpg_key.split(' ')[1] + '\t' + cpg_key.split(' ')[2] + '\t' +  pos_dic[pos_key] + '\n')
						check.append(pos_dic[pos_key])
            
            
with open(sys.argv[1], 'r') as bed_file, open(sys.argv[1].split('_')[0] + '_Plus_group.txt', 'w') as plus, open(sys.argv[1].split('_')[0] + '_Minus_group.txt', 'w') as minus, open(sys.argv[1].split('_')[0] + '_Zero_group.txt' ,'w') as zero , open(sys.argv[1].split('_')[0] + '_Increasing_group.txt', 'w') as increase, open(sys.argv[1].split('_')[0] + '_Decreasing_group.txt', 'w') as decrease:
	for line in bed_file:
		line = line.strip()
		Character = line.split('\t')
		E_zero = float(Character[4].split(';')[0])
		T_zero = float(Character[5].split(';')[0])
		L_zero = float(Character[6].split(';')[0])
		T_E = Character[7]
		T_L = Character[8]
		T_E = T_E.split(';')
		T_L = T_L.split(';')
		if T_E[1] == '+' and T_L[1] == '+':
			plus.write(line + '\n')
		elif T_E[1] == '-' and T_L[1] == '-':
			minus.write(line + '\n')
		elif E_zero == 0 and T_zero == 0 and L_zero == 0:
			zero.write(line + '\n')
		elif float(T_L[0]) - float(T_E[0]) > 0 or T_E[1] == '.' and T_L[1] == '+' or T_E[1] == '-' and T_L[1] == '+' or T_E[1] == '-' and T_L[1] == '.':
			increase.write(line + '\n')
		elif float(T_L[0]) - float(T_E[0]) < 0 or T_E[1] == '.' and T_L[1] == '-' or T_E[1] == '+' and T_L[1] == '-' or T_E[1] == '+' and T_L[1] == '.':
			decrease.write(line + '\n')
