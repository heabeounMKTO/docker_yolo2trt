IOU_THRES ?= 0.65
CONF_THRES ?= 0.8
IMG_SIZE ?= 320
CUDA_DEVICE ?= 0
DOCKER_REGISTRY ?= localhost:5000
DETECT_BASE ?= detectbase
TRT_CONVBASE ?= trtconvbase
TRT_CONV ?= trtconv


trtbase:
	docker build -f Dockerfile.base -t ${DOCKER_REGISTRY}/${TRT_CONVBASE} .


trtconvert: trtbase
	docker build -f Dockerfile.trtconvert -t ${DOCKER_REGISTRY}/${TRT_CONV} .


# make a engine
trt_engine: trtconvert
	docker run -it --gpus all -v ${MODEL_DIR}:/home/models ${DOCKER_REGISTRY}/${TRT_CONV} make end2end MODEL_DIR=${MODEL_DIR} MODEL_NAME=${MODEL_NAME}


# pt => trt
end2end:
	python3 yolov7/export.py --weights models/${MODEL_NAME}.pt --grid --end2end --simplify --topk-all 100 --iou-thres ${IOU_THRES} --conf-thres ${CONF_THRES} --img-size ${IMG_SIZE} ${IMG_SIZE} --dynamic-batch --device ${CUDA_DEVICE}
	rm ${MODEL_NAME}.torchscript.pt 
	rm ${MODEL_NAME}.torchscript.ptl
	python3 build_engine.py -o models/${MODEL_NAME}.onnx -e models/${MODEL_NAME}.trt --fp16 --batch-size 1 4 8
