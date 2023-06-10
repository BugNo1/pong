#ifndef RACKETMODEL_H
#define RACKETMODEL_H

#include <QObject>
#include <QTimer>
#include <QMutex>

class RacketModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(int ballHits READ ballHits WRITE setBallHits NOTIFY ballHitsChanged)
    Q_PROPERTY(int ballWins READ ballWins WRITE setBallWins NOTIFY ballWinsChanged)

public:
    RacketModel(QObject *parent=0);
    RacketModel(int initialSpeed, int initialSize, QObject *parent=0);

    Q_INVOKABLE void initialize();

    int ballHits();
    void setBallHits(int coins);
    Q_INVOKABLE void addBallHit();

    int ballWins();
    void setBallWins(int wins);
    Q_INVOKABLE void addBallWin();

    int speed();
    void setSpeed(int speed);
    Q_INVOKABLE void startSpeedRun(int speed, int duration);

    int size();
    void setSize(int size);
    Q_INVOKABLE void startSizeRun(int size, int duration);

signals:
    void speedChanged();
    void sizeChanged();
    void ballHitsChanged();
    void ballWinsChanged();
    void itemTimerFinished();

public slots:
    void speedTimerSlot();
    void sizeTimerSlot();

private:
    int m_hits;
    int m_wins;
    int m_speed;
    int m_initialSpeed;
    int m_size;
    int m_initialSize;
    QTimer m_speedTimer;
    QTimer m_sizeTimer;
};

#endif // RACKETMODEL_H
