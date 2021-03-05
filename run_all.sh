#!/usr/bin/env bash

cifar_str="cifar_"
mnist_str="mnist_"

# experiment 1 
for pruner_name in "rand" "snip" "grasp" "synflow"
do
  expid_name="1_${mnist_str}${pruner_name}"
  pruner_str="${pruner_name}"
  python main.py --model-class default --model fc --dataset mnist --experiment singleshot --pruner ${pruner_str} --compression 1 --expid ${expid_name} --post-epoch 10
done
# have to deal with magnitue pruning seperately because the pre-epochs needs to be set to 200
python main.py --model-class default --model fc --dataset mnist --experiment multishot --pruner-list mag --compression-list 1 --pre-epochs 200 --expid 1_mnist_mag --post-epoch 10 --level-list 1

# second set of experiments 
mag="mag"
for compression in "0.05" "0.1" "0.2" "0.5" "1" "2"      ### Outer for loop ###
do
    for pruner_name in "rand" "snip" "grasp" "synflow" ### Inner for loop ###
    do
          expid_name="${compression}_${cifar_str}${pruner_name}"
          python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment singleshot --pruner ${pruner_name} --compression ${compression} --expid ${expid_name} --post-epoch 100
    done
    mag_name="${compression}_${cifar_str}${mag}"
    python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment multishot --pruner mag --compression-list ${compression} --pre-epochs 200 --expid ${mag_name} --post-epoch 100 --level-list 1
done
