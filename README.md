# react-native-cppay

这个是银联的私有定制库，是为了自己项目定做的iOS库。

使用方法：

1：安装

npm install react-native-cppay;

react-native link;

调用模式是先添加文件包银联提供的静态包CPPaySDK

然后添加CFNetwork.framework,SystemConfiguration.framwork,libz.tbd,libc++.tbd;

调用代码：

import CPPay from 'react-native-cppay';

CPPay.startPay({
        AccessType : '',
        AcqCode : '',
        BankInstNo : '',
        BusiType : '0001',
        CardTranData : '',
        CommodityMsg : "",
        CurryNo : 'CNY',
        InstuId : "",
        MerBgUrl : "http://10.118.130.35:9080/CPOA_TEST/pages/STDAS/pebResponse.jsp",
        MerId : '000000000000001',
        MerOrderNo : dateStr+timeStr,
        MerPageUrl : "",
        MerResv : "",
        MerSplitMsg : "",
        OrderAmt : '000000000008',
        PayTimeOut : "",
        RemoteAddr : "192.168.56.101",
        RiskData : "",
        Signature : "",
        SplitMethod : "",
        SplitType : "",
        TimeStamp : "",
        TranDate : dateStr,
        TranReserved : "",
        TranTime : timeStr,
        TranType : '0005',
        Version : '20140728',
    },(infos)=>{
      console.log('INFOS+++++++++++>',infos);
    });
