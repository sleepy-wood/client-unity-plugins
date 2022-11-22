typedef struct {
    _Bool isStationary;
    double accelerationMagnitudeInG;
    double heartRateStandardDeviationInBpm;
    double heartRateAverageInBpm;
    double heartRateIntervalStandardDeviationInSeconds;
    double heartRateIntervalAverageInSeconds;
    double networkOutput;
    int sleepState;
} SleepDetectionResult;
