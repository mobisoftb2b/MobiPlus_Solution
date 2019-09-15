using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Tasks
{
    public class TaskModel
    {
        public long? CountryID { get; set; }
        public long? TaskID { get; set; }
        public long? AgentID { get; set; }
        public string DriverName { get; set; }
        public string TaskDesc { get; set; }
        public int? TaskTypeID { get; set; }
        public string TaskTypeDesc { get; set; }
        public string PopulationType { get; set; }
        public string CustomerCode { get; set; }
        public string CustAddress { get; set; }
        public string CustCity { get; set; }
        public int? UserID { get; set; }
        public string TasksConditions { get; set; }
        public string TaskUser { get; set; }
        public string UserNotes { get; set; }
        public string TaskStatusName { get; set; }
        public string imgStatus { get; set; }
        public long? TopicID { get; set; }
        public string SubTopic { get; set; }
        public long? ClassificationID { get; set; }
        public long? PriorityID { get; set; }
        public int? ConditionID { get; set; }
        public int? TaskStatusID { get; set; }
        public string UsersTasksName { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
    }
}
