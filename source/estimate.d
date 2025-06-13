module estimate;

import std.format;

struct Estimate
{
    int days;
    int hours;
    int minutes;

    this(int days, int hours, int minutes)
    {
        hours += minutes / 60;
        minutes = minutes % 60;

        days += hours / 8;
        hours = hours % 8;

        this.days = days;
        this.hours = hours;
        this.minutes = minutes;
    }

    int toMinutes()
    {
        return this.days * 8 * 60 + this.hours * 60 + this.minutes;
    }

    Estimate estimateTime()
    {
        if (this.days == 0 && this.hours == 0)
        {
            if (this.minutes < 30)
            {
                return Estimate(0, 0, 30);
            }
            return Estimate(0, 0, cast(int)(minutes * 1.5));
        }

        if (this.days == 0)
        {
            return Estimate(0, cast(int)(this.hours * 1.5), cast(int)(this.minutes * 1.5));
        }

        if (this.days < 2)
        {
            return Estimate(2, this.hours, this.minutes);
        }

        if (this.days < 5)
        {
            return Estimate(5, this.hours, this.minutes);
        }

        return Estimate(cast(int)(this.days * 1.5), this.hours, this.minutes);
    }

    private string breakdownFormat(string rowName, int minutes, double ratio)
    {
        int mins = (cast(int)(minutes * ratio));
        int days = (mins / 60) / 8;
        int hours = (mins / 60) % 60;

        return format(rowName ~ ": %d days, %d hours, %d minutes\n", days, hours, mins / 60);
    }

    string breakdown()
    {
        double workAmount = 0.4;
        double communicationAmount = 0.25;
        double reviewAmount = 0.15;
        double testingAmount = 0.2;

        int minutes = this.toMinutes();

        return breakdownFormat("Work", minutes, workAmount) ~ breakdownFormat("Communication",
                minutes, communicationAmount) ~ breakdownFormat("Review",
                minutes, reviewAmount) ~ breakdownFormat("Testing", minutes, testingAmount);
    }
}
