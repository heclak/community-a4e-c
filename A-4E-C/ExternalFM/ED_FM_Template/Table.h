#ifndef TABLE_H
#define TABLE_H
#pragma once
//#include <stdlib.h>
#include <vector>
class Table
{
public:
	Table(const std::vector<double> table, double min, double max) :
		m_table(table),
		m_min(min),
		m_max(max)
	{
		m_dx = (max - min) / (double)table.size();
		m_minIndex = min / m_dx;
	}

	double operator()(double value)
	{

		if (m_table.size() == 1)
			return m_table[0];

		double index = (value - m_min) / m_dx;

		int lower = floor(index);
		int upper = ceil(index);

		if (lower == upper)
			upper++;

		if (lower < 0)
			return m_table.front();
		if (upper >= m_table.size())
			return m_table.back();

		double lowerX = (double)lower * m_dx + m_min;
		double upperX = (double)upper * m_dx + m_min;

		return (value - lowerX) * ((m_table[upper] - m_table[lower]) / (upperX - lowerX)) + m_table[lower];
	}
	double operator()(double value, bool print)
	{

		if (m_table.size() == 1)
			return m_table[0];

		double index = (value - m_min) / m_dx;

		int lower = floor(index);
		int upper = ceil(index);

		if (lower == upper)
			upper++;

		printf("lower %d, upper %d\n", lower, upper);

		if (lower < 0)
			return m_table.front();

		if (upper >= m_table.size())
			return m_table.back();
		

		double lowerX = (double)lower * m_dx + m_min;
		double upperX = (double)upper * m_dx + m_min;

		return (value - lowerX) * ((m_table[upper] - m_table[lower]) / (upperX - lowerX)) + m_table[lower];
	}

private:
	const std::vector<double> m_table;
	double m_dx;
	double m_min;
	double m_max;
	int m_minIndex;
};



#endif
