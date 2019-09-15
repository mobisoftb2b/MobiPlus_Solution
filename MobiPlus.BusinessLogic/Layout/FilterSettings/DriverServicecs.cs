using DAL.LayoutRepository.FilterSettings;
using MobiPlus.Models.Common;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Hardware;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.BusinessLogic.Layout.FilterSettings
{
   public class DriverServicecs : IFilterRepository<DriverModel, FilterParams>
    {
        protected DriverRepository _repository;
        public DriverServicecs()
        {
            this._repository = new DriverRepository();
        }      

        public async Task<IEnumerable<DriverModel>> GetDataByID(FilterParams param)
        {
            return await this._repository.GetDataByID(param);
        }

        public async Task<IEnumerable<DriverModel>> GetAgentsLAsync(FilterParams param)
        {
            return await this._repository.GetFilteredData(param);
        }
        public IEnumerable<DriverModel> GetAgentsL(FilterParams param)
        {
            return this._repository.GetAgentsL(param);
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
    }
}
