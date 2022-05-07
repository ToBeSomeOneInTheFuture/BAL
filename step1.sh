#!bin/bash
#get data,split and link
if [ -a ./lib.txt ];then
echo "txtfile found"
else
mv *.txt lib.txt
fi
dos2unix ./lib.txt
mkdir data raw_data
cp ../tool/Get_data.pl ../tool/split_library/ ./raw_data/ -rf
cp ./lib.txt ./raw_data/
cd ./raw_data/
perl ./Get_data.pl
cd ../data/
path=`pwd`
cut -f 1,4 ../lib.txt|while read sample lib;do
	ln -sf ../raw_data/${lib}/split_out/*/result/split/${sample} ./${sample}
done
#qiime
cut -f1 ../lib.txt|while read sample;do 
	csub -q batch -N qiime_${sample} -p4 -m 4gb -w 1000:00:00 -c " 
	cd $path
	sh /datapool/stu/chenzhen/project/tool/qiime_sickle_spades.sh ${sample}
	"
done
