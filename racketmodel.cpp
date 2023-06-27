#include <QDebug>
#include <QtMath>
#include "racketmodel.h"

RacketModel::RacketModel(QObject *parent)
    : QObject(parent)
{
}

RacketModel::RacketModel(int initialSpeed, int initialSize, QObject *parent)
    : QObject(parent), m_initialSpeed(initialSpeed), m_initialSize(initialSize)
{
    m_speedTimer.setSingleShot(true);
    connect(&m_speedTimer, SIGNAL(timeout()), this, SLOT(speedTimerSlot()));
    m_sizeTimer.setSingleShot(true);
    connect(&m_sizeTimer, SIGNAL(timeout()), this, SLOT(sizeTimerSlot()));
}

void RacketModel::initialize()
{
    setSpeed(m_initialSpeed);
    setSize(m_initialSize);
    setBallHits(0);
    setBallWins(0);
    setItemHits(0);
}

int RacketModel::ballHits()
{
    return m_hits;
}

void RacketModel::setBallHits(int hits)
{
    if (hits != m_hits) {
        m_hits = hits;
        emit ballHitsChanged();
    }
}

void RacketModel::addBallHit() {
    setBallHits(m_hits + 1);
}

int RacketModel::ballWins()
{
    return m_wins;
}

void RacketModel::setBallWins(int wins)
{
    if (wins != m_wins) {
        m_wins = wins;
        emit ballWinsChanged();
    }
}

void RacketModel::addBallWin() {
    setBallWins(m_wins + 1);
}

int RacketModel::itemHits()
{
    return m_itemHits;
}

void RacketModel::setItemHits(int hits)
{
    if (hits != m_itemHits) {
        m_itemHits = hits;
        emit itemHitsChanged();
    }
}

void RacketModel::addItemHit() {
    setItemHits(m_itemHits + 1);
}

int RacketModel::speed()
{
    return m_speed;
}

void RacketModel::setSpeed(int speed)
{
    if (speed != m_speed) {
        m_speed = speed;
        emit speedChanged();
    }
}

void RacketModel::startSpeedRun(int speed, int duration)
{
    setSpeed(speed);
    m_speedTimer.start(duration);
}

void RacketModel::speedTimerSlot()
{
    setSpeed(m_initialSpeed);
    emit itemTimerFinished();
}

int RacketModel::size()
{
    return m_size;
}

void RacketModel::setSize(int size)
{
    if (size != m_size) {
        m_size = size;
        emit sizeChanged();
    }
}

void RacketModel::startSizeRun(int size, int duration)
{
    setSize(size);
    m_sizeTimer.start(duration);
}

void RacketModel::sizeTimerSlot()
{
    setSize(m_initialSize);
    emit itemTimerFinished();
}
