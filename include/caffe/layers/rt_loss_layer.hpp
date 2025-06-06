#ifndef CAFFE_RT_LOSS_LAYER_HPP_
#define CAFFE_RT_LOSS_LAYER_HPP_

#include <vector>

#include "caffe/blob.hpp"
#include "caffe/layer.hpp"
#include "src/caffe.pb.h"

#include "caffe/layers/loss_layer.hpp"

namespace caffe {
    
/**
 * @brief Injects rt loss
 */
    template <typename Dtype>
    class RTLossLayer : public Layer<Dtype> {
    public:
	explicit RTLossLayer(const LayerParameter& param)
	    : Layer<Dtype>(param) {}
	virtual void LayerSetUp(const vector<Blob<Dtype>*>& bottom,
				const vector<Blob<Dtype>*>& top);
	virtual void Reshape(const vector<Blob<Dtype>*>& bottom,
			     const vector<Blob<Dtype>*>& top);
	
	virtual inline const char* type() const { return "RTLoss"; }
	
	virtual inline int ExactNumBottomBlobs() const { return 0; }
	
	virtual inline bool AutoTopBlobs() const { return true; }
	
	virtual inline int ExactNumTopBlobs() const { return 1; }
	
	virtual inline bool AllowForceBackward(const int bottom_index) const {
	    return false;
	}
	
	virtual inline void setLoss(Dtype l) {
	    loss = l;
	};
	
    protected:
	/// @copydoc RTLossLayer
	virtual void Forward_cpu(const vector<Blob<Dtype>*>& bottom,
				 const vector<Blob<Dtype>*>& top);
	virtual void Forward_gpu(const vector<Blob<Dtype>*>& bottom,
				 const vector<Blob<Dtype>*>& top);
	
	virtual void Backward_cpu(const vector<Blob<Dtype>*>& top,
				  const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom);
	virtual void Backward_gpu(const vector<Blob<Dtype>*>& top,
				  const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom);
	
	double loss = 0;
    };
    
}  // namespace caffe

#endif
