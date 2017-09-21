//
//  ViewController.swift
//  UIPageViewControllerDemo
//
//  Created by Niks on 21/12/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIPageViewController, UIPageViewControllerDataSource
{
    //var arrPageTitle: NSArray = NSArray()
    //var arrPagePhoto: NSArray = NSArray()
    
    var paginas : [Pagina] = []
    var fetchResultsController : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var libros : [Libro] = []
    var fetchResultsControllerLibro : NSFetchedResultsController<Libro>!
    var libro : Libro?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //arrPageTitle = ["This is The App Guruz", "This is Table Tennis 3D", "This is Hide Secrets"];
        //arrPagePhoto = ["1a.jpg", "2a.jpg", "3a.jpg"];
        
        //Ver()
        
        self.dataSource = self
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToNextPage), name: PageContentViewController.NotificationIdentifierSinc, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        NotificationCenter.default.removeObserver(self, name: PageContentViewController.NotificationIdentifierSinc, object: nil);
        
        
    }


// MARK:- UIPageViewControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        return getViewControllerAtIndex(index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        let miLibro = self.libro
        let cantPagina = miLibro!.paginas?.count
        
        index += 1;
        if (index == cantPagina)
        {
            //goToFin()
            return nil;
        }
        return getViewControllerAtIndex(index)
    }

// MARK:- Other Methods
    func getViewControllerAtIndex(_ index: NSInteger) -> PageContentViewController
    {
        let miLibro = self.libro
        let miPagina = miLibro!.paginas![index] as! Pagina
        let totales = miLibro?.paginas?.count
        
        //let pagina : Pagina!
        //pagina = self.paginas[index]
        
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController

        pageContentViewController.strTitle = ""
        pageContentViewController.strPhotoName = ""
        pageContentViewController.pagina = miPagina
        pageContentViewController.pageIndex = index
        pageContentViewController.pageTotales = totales!
        
        return pageContentViewController
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    
    @objc func goToNextPage(){
        
        guard let currentViewController = self.viewControllers?.first
            else {
            return
        }
        
        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController )
            else {
                return
        
        }
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    func goToFin(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    //*********************
    
    /*
    func Ver (){
        let fetchRequest : NSFetchRequest<Pagina> = NSFetchRequest(entityName: "Pagina")
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchResultsController.delegate = self as? NSFetchedResultsControllerDelegate
            
            
            do {
                try fetchResultsController.performFetch()
                self.paginas = fetchResultsController.fetchedObjects!
                
                //let dolencia = dolencias[3]
                
                // for name in casos {
                
                //   let caso = name
                //print (caso.caso)
                
                
                // }
                
                //self.tableView.refreshControl?.endRefreshing()
                //tableView.reloadData()
                
                //print("---: \(dolencia.nombre) ---: \(dolencias.count)")
                
                
            } catch {
                print("Error: \(error)")
            }
            
        }
        
    }
    */
    
    
}

