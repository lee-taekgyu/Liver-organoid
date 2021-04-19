#본 코드는 Bismark CpG report 파일로부터 여러개의 sample을 position별로 통합하고 filtering 조건을 부여하여 유의미한 methylation정보를 통합하여 경향성을 파악하는 코드이다
#Output으로는 filtering 전, 후, ref Bed file로 부터 CpG site를 통합하여 값들을 나타낸 파일(Sum + Mean), Tendency file이 나온다

import sys
import time
import numpy as np
import argparse

parser = argparse.ArgumentParser(description='Code Usage')
parser.add_argument('name',metavar='NAME', help='input name you want')
parser.add_argument('cov_num', metavar='F', help='input filtering number')
parser.add_argument('Ref bed file', metavar='R',help='input Refernce bed file')
parser.add_argument('CpG report files', metavar='Files', nargs='+', help='input Bismark CpG report files')

args = parser.parse_args()

start_time = time.time()

Chromosome = []
for num in range(1,23):
	Chromosome.append('chr'+str(num))
Chromosome.extend(['chrX','chrY'])

data_files = sys.argv[4:]  #Bismark CpG report file

Length = len(data_files)

for chromosome in Chromosome:
	data_dict = {}
	Pos_dict = {}
	for dfile in data_files:
		dopen = open(dfile)
		dlines = dopen.readlines()
		dopen.close()
		data_dict[dfile] = {}
		for dline in dlines:
			line = dline.strip().split('\t')
			Chr = line[0]
			Position = line[1]
			if line[3] == '0':
				Description = line[3], line[4], str(0), line[6]
			else:
				Description = line[3], line[4], str(round(int(line[3]) / (int(line[3]) + int(line[4]))*100,2)), line[6]
			Description = ';'.join(Description)
			if Chr == chromosome:
				data_dict[dfile][Position] = Description

	with open(sys.argv[4], 'r') as handle0:  #input bed file
		for line0 in handle0:
			line0 = line0.strip().split('\t')
			Chr0 = line0[0]
			Position0 = line0[1]
			if Chr0 == chromosome:
				Pos_dict[Position0] = Chr0
				
	key_Position = data_dict[dfile].keys()
	key_Chromosome = Pos_dict.keys()	

	with open(sys.argv[1]+'_total_merge.txt', 'a') as handle1:   # name 
		for key in key_Position:
			handle1.write(Pos_dict[key] + '\t' + key)
			for dfile in data_files:
				handle1.write('\t' + data_dict[dfile][key])
			handle1.write('\n')

	data_dict.clear()
	Pos_dict.clear()

with open(sys.argv[1] + '_filtered_merge.txt' , 'w') as final_merge:
	with open(sys.argv[1]+'_total_merge.txt', 'r') as merge_file:
		for line in merge_file:
			line_list = line.strip().split('\t')
			temp_list = []
			for i in range(0,Length):
				inp = line_list[2+i].split(';')
				globals()['var{}'.format(i)] = inp
				if int(globals()['var{}'.format(i)][0]) + int(globals()['var{}'.format(i)][1]) < int(sys.argv[2]):
					continue
				else:
					temp_list.append(int(globals()['var{}'.format(i)][0]))
					if len(temp_list) == Length :
						final_merge.write('\t'.join(line_list) + '\n')

for Chr in Chromosome:
	cpg_dic = {}
	with open(sys.argv[1]+'_filtered_merge.txt' ,'r') as CPG:          #filtered file
		for line in CPG:
			cpg_list = line.strip().split('\t')
			if cpg_list[0] == Chr:
				cpg_dic[cpg_list[1]] = ','.join(cpg_list[2:])
				cpg_character = ",".join(cpg_list[2:])
				cpg_character = cpg_character.split(';')
				cpg_character = ','.join(cpg_character)
				cpg_character = cpg_character.split(',')
				cpg_character = cpg_character[0::4] + cpg_character[1::4]
				cpg_character = ','.join(cpg_character) 
				cpg_dic[cpg_list[1]] = cpg_character

	bed_dic = {}
	result = {}
	with open(sys.argv[3], 'r' ) as bed:       #reference CpG bed file
		for bed_line in bed:
			bed_list = bed_line.strip().split('\t')
			if bed_list[0] == Chr:
				Start = int(bed_list[1])
				End = int(bed_list[2])
				for cpg_site in list(cpg_dic.keys()):
					if Start <= int(cpg_site) <= End:
						if Chr + ' ' + str(Start) +' '+ str(End) not in result:
							result[Chr + ' ' + str(Start) + ' ' + str(End)] = cpg_dic[cpg_site]
						else:
							result[Chr + ' ' + str(Start) + ' ' + str(End)] += ';'+cpg_dic[cpg_site]
					else:
						continue

	with open(sys.argv[1] + '_sum.txt', 'a') as handle:             #Sum value
		for key in result.keys():
			Coverage = result[key].split(',')
			Coverage = ','.join(Coverage)
			Coverage = Coverage.replace(',' ,';')
			Coverage = Coverage.split(';')
			CpG_num = str(int(len(Coverage)/6))
			Coverage = list(map(int, Coverage))
			TEMP = []
			for i in range(0,Length):
				TEMP.append(sum(Coverage[i::Length*2]))
				TEMP.append(sum(Coverage[i+Length::Length*2]))
			TEMP = list(map(str, TEMP))
			TEMP = ','.join(TEMP)
			TEMP = TEMP.replace(',',' ')
			handle.write(key + '\t' + CpG_num + '\t' + TEMP + '\n')

	with open(sys.argv[1] + '_mean.txt', 'a') as handle:            #Mean value
		for key in result.keys():
			Coverage = result[key].split(',')
			Coverage = ','.join(Coverage)
			Coverage = Coverage.replace(',' ,';')
			Coverage = Coverage.split(';')
			CpG_num = str(int(len(Coverage)/6))
			Coverage = list(map(int, Coverage))
			TEMP = []
			for i in range(0,Length):
				TEMP.append(np.around(np.mean(Coverage[i::Length*2])))
				TEMP.append(np.around(np.mean(Coverage[i+Length::Length*2])))
			TEMP = list(map(str, TEMP))
			TEMP = ','.join(TEMP)
			TEMP = TEMP.replace(',',' ')
			handle.write(key + '\t' + CpG_num + '\t ' + TEMP + '\n')

with open(sys.argv[1] + '_Tendency.txt', 'w') as tendency:
	with open(sys.argv[1] + '_sum.txt', 'r') as handle:
		for line in handle:
			line1 = line.strip()
			if '\t' in line:
				line = line.strip()
				line = line.replace('\t', ' ')
				line = line.split(' ')
				Chr = line[0]
				Start = line[1]
				End = line[2]
				CpG_NUM = line[3]
				E = line[4]
				T = line[6]
				L  = line[8]
				T_E = int(line[6]) - int(line[4])
				if T_E > 0 :
					T_E = str(T_E) + ';' + '+'
				elif T_E < 0:
					T_E = str(T_E) + ';' + '-'
				elif T_E == 0 :
					T_E = str(T_E) + ';' + '.'
				T_L = int(line[6]) - int(line[8])
				if T_L > 0 :
					T_L = str(T_L) + ';' + '+'
				elif T_L < 0:
					T_L = str(T_L) + ';' + '-'
				elif T_L == 0 :
					T_L = str(T_L) + ';' + '.'
				tendency.write(Chr + '\t' + Start + '\t' + End + '\t' + CpG_NUM + '\t' + E + '\t' +line[5] + '\t' +  T + '\t' + line[7] + '\t' + L + '\t' + line[9] + '\t' +  str(T_E) + '\t' + str(T_L) + '\n')



print("Working Time {} sec." .format(round(time.time() - start_time,2)))
