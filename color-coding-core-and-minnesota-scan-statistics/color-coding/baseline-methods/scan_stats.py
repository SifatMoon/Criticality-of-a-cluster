import numpy as np

def BJ(anom_count, set_size, alpha):
    assert(set_size >= 0 and anom_count <= set_size)
    ratio = float(anom_count) / set_size
    if ratio <= alpha:
        return 0.
    return set_size * KL(ratio, alpha)

def KL(a, b):
    if (a == 0):
        return (1 - a) * np.log((1 - a) / (1 - b))
    if (a == 1):
        return a * np.log(a / b)
    return a * np.log(a / b) + (1 - a) * np.log((1 - a) / (1 - b))


def kulldorff(c_in, b_in, c_all, b_all):
    assert(0 <= b_in <= b_all)
    ratio_in = float(c_in) / b_in
    ratio_out = float(c_all - c_in) / (b_all - b_in)
    ratio_all = float(c_all) / b_all
    assert(ratio_in <= 1 and ratio_out <= 1 and ratio_all <= 1)
    if ratio_in < ratio_all:
        return 0;
    if ratio_out == 0:
        return  c_in * np.log(ratio_in) - c_all * np.log(ratio_all)
    return c_in * np.log(ratio_in) + (c_all - c_in) * np.log(ratio_out) - c_all * np.log(ratio_all)


def kulldorff_bernoulli(c_in, b_in, c_all, b_all):
        if (c_in == 0 or b_in == 0):
            return 0
        c_out = c_all - c_in
        b_out = b_all - b_in;
        ratio_in =  float(c_in) / b_in;
        ratio_out = float(c_out) / b_out;       
        ratio_all = float(c_all) / b_all;
        if (ratio_in > 1 or ratio_all > 1):
            errorMessage = "Observed counts must be lower than baseline counts. "
            errorMessage += "Received observedCount = " + c_in + ", baselineCount = " + b_in
            errorMessage += ", totalObserved = " + c_all + ", totalBaseline = " + b_all
            raise Exception,  errorMessage
        
        # by definition
        if (ratio_in <= ratio_all):
            return 0;
        
        score = c_in * np.log(ratio_in);
        # avoid log 0
        if ((1 - ratio_in) > 0):
            score += (b_in - c_in) * np.log(1 - ratio_in);
        if (ratio_out > 0):
            score += c_out * np.log(ratio_out);
        if ((1 - ratio_out) > 0):
            score += (b_out - c_out) * np.log(1 - ratio_out);
        score -=  (c_all * np.log(ratio_all) +  (b_all - c_all) * np.log(1 - ratio_all));
        return score;
