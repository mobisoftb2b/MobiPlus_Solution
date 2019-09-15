using System.Collections.Generic;

namespace MobiPlus.Models.AgentDailyTasks
{
    public class Tasks2Agent
    {
        public string AgentID { get; set; }
        public List<DailyTask> DailyTasks { get; set; }
    }
}