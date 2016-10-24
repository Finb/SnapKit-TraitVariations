//
//  ViewController.swift
//  SnapKit-TraitVariations
//
//  Created by huangfeng on 16/10/21.
//  Copyright © 2016年 me.fin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = UIColor.red
        self.view .addSubview(view)
        
        let view2 = UIView()
        view2.backgroundColor = UIColor.blue
        self.view .addSubview(view2)
        
        
        //        // 所有屏幕都使用的约束
        //        view.kv
        //            .makeConstraints({ (make) in
        //                make.top.left.right.equalTo(self.view)
        //                make.bottom.equalTo(self.view.snp.centerY);
        //            })
        //
        //        view2.kv
        //            .makeConstraints({ (make) in
        //                make.bottom.left.right.equalTo(self.view)
        //                make.top.equalTo(view.snp.bottom).offset(10);
        //            })
        
        
        
        // 窄 宽度屏幕使用的约束
        view.kv
            .wC.hR
            .makeConstraints({ (make) in
                make.top.left.right.equalTo(self.view)
                make.bottom.equalTo(self.view.snp.centerY);
            })
        
        view2.kv
            .wC.hR
            .makeConstraints({ (make) in
                make.bottom.left.right.equalTo(self.view)
                make.top.equalTo(view.snp.bottom).offset(10);
            })
        
        
        //宽 宽度屏幕使用的约束
        view.kv
            .wC.hC
            .makeConstraints({ (make) in
                make.top.left.bottom.equalTo(self.view)
                make.right.equalTo(self.view.snp.centerX);
            })
        
        view2.kv
            .wC.hC
            .makeConstraints({ (make) in
                make.top.right.bottom.equalTo(self.view)
                make.left.equalTo(self.view.snp.centerX);
            })
        
        //用iPhone6 运行，然后旋转屏幕

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

