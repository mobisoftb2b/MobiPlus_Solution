using DAL.LayoutRepository.FilterSettings;
using MobiPlus.Models.Common;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MobiPlus.BusinessLogic.Layout.FilterSettings
{
    public class DistributionService : IFilterRepository<DistributionModel, FilterParams>
    {
        protected DistributionRepository repository;

        public DistributionService()
        {
            this.repository = new DistributionRepository();
        }

        public async Task<IEnumerable<DistributionModel>> GetDataByID(FilterParams param)
        {
            return await this.repository.GetDataByID(param);
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
