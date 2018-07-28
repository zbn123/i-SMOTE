#!/bin/sh


# Constant Options
DATA_REDUCTION_RATE=0.1
GAMMA=auto


# Log2 is useful in hparam search
function log2 {
    local x=0
    for (( y=$1-1 ; $y > 0; y >>= 1 )) ; do
        let x=$x+1
    done
    echo $x
}


# Loop over the experiment options in parallel
for METHOD in "SMOTE" "I-SMOTE"
do
	for C in $(log2 20) $(log2 10) $(log2 5)
	do
		for MINORITY_SIZE_TARGET in 2 3 5 10 25 75 200
		do
			for EXPANSION_RATE in 10 50 100 250
			do
				for K in 2 5 10
				do
					for RANDOMNESS in {1..10}
					do
						if [ $MINORITY_SIZE_TARGET -ge $K ]; then
							python main.py $DATA_REDUCTION_RATE $METHOD $C $GAMMA $MINORITY_SIZE_TARGET $EXPANSION_RATE $K 1 &
							python main.py $DATA_REDUCTION_RATE $METHOD $C $GAMMA $MINORITY_SIZE_TARGET $EXPANSION_RATE $K 2 &
							python main.py $DATA_REDUCTION_RATE $METHOD $C $GAMMA $MINORITY_SIZE_TARGET $EXPANSION_RATE $K 8 &
							python main.py $DATA_REDUCTION_RATE $METHOD $C $GAMMA $MINORITY_SIZE_TARGET $EXPANSION_RATE $K 5 
							wait
						fi
					done
				done
			done
		done
	done
done

wait

