using DAL.LayoutRepository.Tasks;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Tasks;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.BusinessLogic.Tasks
{
    public class TaskService : IFilterRepository<TaskModel, FilterParams>
    {
        protected TaskRepository _repository;
        public TaskService()
        {
            this._repository = new TaskRepository();
        }

        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }




        #endregion

        public Task<IEnumerable<TaskModel>> GetDataByID(FilterParams param)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<TaskModel>> Layout_Tasks_GetAllTasksAsync(FilterParams inParams)
        {
            return await this._repository.GetFilteredData(inParams);
        }
        public IEnumerable<TaskModel> Layout_Tasks_GetAllTasks(FilterParams inParams)
        {
            return this._repository.MPLayout_Tasks_GetAllTasks(inParams);
        }

        public async Task<IEnumerable<TaskModel>> Layout_GetTaskTypesAsync(FilterParams inParams)
        {
            return await this._repository.Layout_GetTaskTypesAsync(inParams);
        }
        public IEnumerable<TaskModel> Layout_GetTaskTypes(FilterParams inParams)
        {
            return this._repository.Layout_GetTaskTypes(inParams);
        }

        public DataTable Layout_GetTaskTypes(int countryID, string conString)
        {
            return DAL.LayoutDAL.Layout_GetTaskTypes(countryID, conString);
        }

        public async Task<IEnumerable<TaskModel>> Layout_SaveTaskAsync(TaskModel param)
        {
            return await this._repository.Layout_SaveTaskAsync(param);
        }
        public IEnumerable<TaskModel> Layout_SaveTask(TaskModel param)
        {
            return this._repository.Layout_SaveTask(param);
        }

        public async Task Layout_DeleteTaskAsync(List<int> param)
        {
            await this._repository.Layout_DeleteTaskAsync(param);
        }
        public void Layout_DeleteTask(List<int> param)
        {
            this._repository.Layout_DeleteTask(param);
        }
        public DataTable Layout_DeleteTask(TaskModel param, string conString)
        {
            return DAL.LayoutDAL.Layout_DeleteTask(param, conString);
        }

        public DataTable Layout_GetDriverTasks(FilterParams inParams, string ConString)
        {
            return DAL.LayoutDAL.Layout_GetDriverTasks(inParams, ConString);
        }
        public DataTable Layout_SaveTask(TaskModel param, string ConString)
        {
            return DAL.LayoutDAL.Layout_SaveTask(param, ConString);
        }
    }
}
