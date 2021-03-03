#!/usr/bin/env bash

CIFAR = "cifar_"
MNIST = "mnist_"

# experiment 1 
for PRUNER_NAME in rand snip grasp synflow
do
  # python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment singleshot --pruner synflow --compression 1 --expid $CIFAR$PRUNER_NAME --post-epoch 100
  python main.py --model-class default --model fc --dataset mnist --experiment singleshot --pruner synflow --compression 1 --expid $MNIST$PRUNER_NAME --post-epoch 10
done
# have to deal with magnitue pruning seperately because the pre-epochs needs to be set to 200
# python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment multishot --pruner mag --compression 1 --pre-epochs 200 cifar_mag
python main.py --model-class default --model fc --dataset mnist --experiment multishot --pruner mag --compression 1 --pre-epochs 200 mnist_mag

# second set of experiments 
MAG = "mag"
for COMPRESSION in 0.05 0.1 0.2 0.5 1 2      ### Outer for loop ###
do

    for PRUNER_NAME in rand snip grasp synflow ### Inner for loop ###
    do
          python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment singleshot --pruner synflow --compression $COMPRESSION --expid $COMPRESSION$CIFAR$PRUNER_NAME --post-epoch 100
    done
    python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment singleshot --pruner mag --compression $COMPRESSION --pre-epochs 200 $COMPRESSION$CIFAR$MAG
done