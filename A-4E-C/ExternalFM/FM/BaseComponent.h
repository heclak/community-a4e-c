#pragma once
class BaseComponent
{
public:
	BaseComponent() {}
	virtual void zeroInit() = 0;
	virtual void coldInit() = 0;
	virtual void hotInit() = 0;
	virtual void airborneInit() = 0;

private:
};