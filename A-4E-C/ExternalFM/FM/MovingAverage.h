#pragma once

template<typename T, size_t N>
class MovingAverage
{
public:

	MovingAverage()
	{
		setAll( 0.0 );
	}

	MovingAverage( T value )
	{
		setAll( value );
	}

	inline void setAll( T value );
	inline T value();
	inline void add( T value );

private:
	T m_values[N];
	size_t m_index = 0;
};

template<typename T, size_t N>
inline void MovingAverage<T,N>::setAll( T value )
{
	for ( size_t i = 0; i < N; i++ )
	{
		m_values[i] = value;
	}
}

template<typename T, size_t N>
inline T MovingAverage<T, N>::value()
{
	T value = 0;
	for ( size_t i = 0; i < N; i++ )
	{
		value += m_values[i];
	}
	value /= (T)N;

	return value;
}

template<typename T, size_t N>
inline void MovingAverage<T, N>::add(T value)
{
	m_values[m_index] = value;
	m_index = ( m_index + 1 ) % N;
}