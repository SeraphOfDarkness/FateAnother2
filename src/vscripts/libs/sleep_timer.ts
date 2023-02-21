export function Sleep(duration: number) 
{
    return new Promise((resolve) => 
    {
        Timers.CreateTimer(duration, () => resolve(""));
    });
}