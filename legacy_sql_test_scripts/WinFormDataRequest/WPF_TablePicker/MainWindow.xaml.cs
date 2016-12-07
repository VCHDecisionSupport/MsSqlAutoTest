using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WPF_TablePicker
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private TestLogEntities _context = new TestLogEntities();
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {

            System.Windows.Data.CollectionViewSource mD_DatabaseViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("mD_DatabaseViewSource")));
            // Load data by setting the CollectionViewSource.Source property:
            // mD_DatabaseViewSource.Source = [generic data source]

            // Load is an extension method on IQueryable,  
            // defined in the System.Data.Entity namespace. 
            // This method enumerates the results of the query,  
            // similar to ToList but without creating a list. 
            // When used with Linq to Entities this method  
            // creates entity objects and adds them to the context. 
            _context.MD_Database.Load();

            // After the data is loaded call the DbSet<T>.Local property  
            // to use the DbSet<T> as a binding source. 
            mD_DatabaseViewSource.Source = _context.MD_Database.Local;

        }

        private void buttonSave_Click(object sender, RoutedEventArgs e)
        {
            // When you delete an object from the related entities collection  
            // (in this case Products), the Entity Framework doesn’t mark  
            // these child entities as deleted. 
            // Instead, it removes the relationship between the parent and the child 
            // by setting the parent reference to null. 
            // So we manually have to delete the products  
            // that have a Category reference set to null. 

            // The following code uses LINQ to Objects  
            // against the Local collection of Products. 
            // The ToList call is required because otherwise the collection will be modified 
            // by the Remove call while it is being enumerated. 
            // In most other situations you can use LINQ to Objects directly  
            // against the Local property without using ToList first. 
            foreach (var product in _context.MD_Object.Local.ToList())
            {
                if (product.MD_Database == null)
                {
                    _context.MD_Object.Remove(product);
                }
            }

            _context.SaveChanges();
            // Refresh the grids so the database generated values show up. 
            this.mD_DatabaseDataGrid.Items.Refresh();
            //this.productsDataGrid.Items.Refresh();
        }
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            base.OnClosing(e);
            this._context.Dispose();
        }

        
    }
}
