#ifndef HealthData_h
#define HealthData_h

typedef struct {
    double startDateInSeconds;
    double endDateInSeconds;
    int value;
} SleepSample;

typedef struct {
    double dateInSeconds;
    // _Bool isMoveMode;
    // double moveTimeInMinutes;
    // double moveTimeGoalInMinutes;
    double activeEnergyBurnedInKcal;
    double activeEnergyBurnedGoalInKcal;
    double exerciseTimeInMinutes;
    double exerciseTimeGoalInMinutes;
    double standHours;
    double standHoursGoal;
} ActivitySample;

#endif
