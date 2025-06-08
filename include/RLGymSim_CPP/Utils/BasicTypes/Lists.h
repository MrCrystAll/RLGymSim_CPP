#pragma once
#include <RLGymSim_CPP/Framework.h>

namespace RLGSC {
	typedef std::vector<float> RG_IMEXPORT FList;
	typedef std::vector<std::vector<float>> RG_IMEXPORT FList2;
	typedef std::vector<int> RG_IMEXPORT IList;
	typedef std::vector<std::vector<int>> RG_IMEXPORT IList2;
}

// FList operators
inline RLGSC::FList& operator +=(RLGSC::FList& list, float val) {
	list.push_back(val);
	return list;
}

inline RLGSC::FList& operator +=(RLGSC::FList& list, const Vec& val) {
	list.push_back(val.x);
	list.push_back(val.y);
	list.push_back(val.z);
	return list;
}

inline RLGSC::FList& operator +=(RLGSC::FList& list, const std::initializer_list<float>& other) {
	list.insert(list.end(), other.begin(), other.end());
	return list;
}

inline RLGSC::FList& operator +=(RLGSC::FList& list, const RLGSC::FList& other) {
	list.insert(list.end(), other.begin(), other.end());
	return list;
}