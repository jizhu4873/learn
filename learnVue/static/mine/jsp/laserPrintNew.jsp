<%@page contentType="text/html; charset=GB18030"%>
<%@page import="java.sql.Connection,
                 java.util.*,
                 java.text.SimpleDateFormat,
                 org.apache.struts.action.ActionErrors,
                 org.apache.struts.action.ActionError,
                 org.apache.struts.Globals,
                 org.apache.struts.action.Action,
                 com.csair.ticketing.common.*,
                 com.csair.ticketing.web.SessionNames,
                 com.csair.document.common.*,
                 com.csair.frame.exception.SystemErrorNo,
                 com.csair.frame.web.LocaleHelper,
                 java.sql.SQLException,
                 java.sql.Connection,
                 com.csair.util.ConnectionFactory,
                 com.csair.document.app.dao.TicketReceiptDAO,
                 com.csair.ticketing.util.TicketConfig,
                 com.csair.document.app.dao.CityCodeDAO,
                 com.csair.frame.common.ParCityAirCode,
                 com.csair.document.common.Flging,
                 com.csair.ticketing.common.Terminal,
                 org.dom4j.Document,
								 org.dom4j.DocumentHelper,
								 org.dom4j.Element"%>
<HTML>
<HEAD>
<LINK href="Master.css" rel="stylesheet" type="text/css">
<LINK href="default.css" rel="stylesheet" type="text/css">
<%
  //解决刷新问题
  response.addHeader("Cache-Control", "no-cache");
  UserLogin userLogin = (UserLogin) session.getAttribute(SessionNames.USER_LOGIN);
  String permission = userLogin.getPermission();
  
  //创建文档
	Document doc = DocumentHelper.createDocument();
	//定义根节点		
	Element ticketdata = doc.addElement("ticketdata");
	doc.setXMLEncoding("UTF-8");
	
  if (permission == null || permission.indexOf("21003") == -1 || permission.indexOf("21004") == -1) {
    ActionErrors errors = new ActionErrors();
    errors.add(ActionErrors.GLOBAL_ERROR,
               new ActionError(SystemErrorNo.NOPERMISSION_ERROR));
    request.setAttribute(Globals.ERROR_KEY, errors);
    ServletContext context = pageContext.getServletContext();
    RequestDispatcher rd = context.getRequestDispatcher("/errorpage.jsp");
    rd.forward(request, response);
    return;
  }
  ArrayList printList = (ArrayList) session.getAttribute(SessionNames.PRINT_LIST);
  ArrayList receiptList = (ArrayList) session.getAttribute(SessionNames.RECEIPT_LIST);
  String printerType = request.getParameter("pType");
  int top = 0;
  if (printerType != null) {
    top = -8;
  }
  OrganizationUnitProfile og = userLogin.getOrganizationUnit();
  String issuedBy = og.getName();
  String sequence = request.getParameter("seq");
  
  //从配置文件中取出F舱打C舱的舱位
  String F2C = TicketConfig.getValue("F2C");
%>
<SCRIPT id="clientEventHandlersJS" LANGUAGE="javascript" type="text/JavaScript">
function window_onload() {
  try {
    var i = 0;
    <%  
    int size = printList.size();
    if (sequence != null && printList.size() != 0) {
      size = 1;
    }
    for(int k = 0;k < size; k++) {
       if (sequence != null){
         k = Integer.parseInt(sequence);
         if (k >= printList.size()) {
           break;
         }
       }
       Ticket ticket = (Ticket)printList.get(k);
       //是否换开标示
        boolean TKT_E = false;
       if(ticket.getOrginalList() != null){
          TKT_E = true ;//换开
        }
       //是否为广长快线 VC=MC=CZ ，CAN-CSX


       //是否国际票标示
       boolean TKT_I = false;
       Pricing Pricing = ticket.getPricing();          
       
       if((Pricing != null && Pricing.getInternationalsale() != null && Pricing.getInternationalsale().equals("I"))||Pricing == null){
         TKT_I = true ;
       }
       
       if (ticket != null) {
         String ticketNumber = ticket.getTicketNumber();
         //政府采购(GP)机票
         String gpFlag = ticket.getOfficialFlag();
         String gpNo = ticket.getOfficialTicketNo();
         String gp = "";
         if(gpFlag!= null && !"".equals(gpFlag)) {
         		if(gpNo!= null && !"".equals(gpNo)){
         				gp = gpFlag + gpNo;
         		}
         } 
         int totalTickets = ticket.getTotalTickets();
         TicketReceipt ticketReceipt = null;
         for(int i = 0; i < receiptList.size(); i++) {
           ticketReceipt = (TicketReceipt)receiptList.get(i);
           if (ticketNumber.equals(ticketReceipt.getTicketNumber())) {
             break;
           }
         }
        String validateCode = " ";
        if (ticketReceipt != null && ticketReceipt.getReceiptNumber() != null) {
          int length = ticketReceipt.getReceiptNumber().length();
          validateCode = ticketReceipt.getReceiptNumber().substring(length-4, length);
        }
        String endorsements = ticket.getEndorsements();
        if (endorsements == null) {
          endorsements = " ";
        } else {
          if(endorsements.trim().equals("退票或签转需退还门票")
          || endorsements.trim().equals("不得签转，退票需退还门票")
          || endorsements.trim().equals("不得签转退票需退还门票")
          || endorsements.trim().equals("不得签转，必须同行，退票需退还门票")
          || endorsements.trim().equals("不得签转必须同行退票需退还门票")){
            endorsements = endorsements + "(值机柜台领门票)";
          }
        }
        endorsements = endorsements.replaceAll("\"", "\\\\\"");
        String ticketNo = ticketNumber.substring(0,3) + "-" + ticketNumber.substring(3,13);
        //（连票），因为换开打印差价的关系。所以连票显示方式改变
        if (ticket.getTotalTickets() > 1) {
           long startNumber = Long.parseLong(ticketNumber) - ticket.getSequence() + 1;
           long endNumber = startNumber + ticket.getTotalTickets() - 1;
           String startNumberStr = Long.toString(startNumber).substring(0,3) + "-" + Long.toString(startNumber).substring(3,13);
            ticketNo += "("+Long.toString(startNumber).substring(11,13)+ "/" + Long.toString(endNumber).substring(11,13)+")";
        }
        String cknTkt = " ";
        if (ticket.getTotalTickets() > 1) {
          long startNumber = Long.parseLong(ticketNumber) - ticket.getSequence() + 1;
          long endNumber = startNumber + ticket.getTotalTickets() - 1;
          String startNumberStr = Long.toString(startNumber).substring(0,3) + "-" + Long.toString(startNumber).substring(3,13);
          cknTkt = startNumber + "/" + Long.toString(endNumber).substring(11,13);
        }

        String dateOfIssue = ticket.getDateOfIssue();
        if (dateOfIssue != null && dateOfIssue.length() == 6) {
          dateOfIssue = "20" + dateOfIssue.substring(0,2) + "-" + dateOfIssue.substring(2,4) + "-" + dateOfIssue.substring(4,6);
        }
        boolean isIssue = false;
        String ticketNumber_old ="";
        
        SimpleDateFormat dateIssueFm = new SimpleDateFormat("yyyy-MM-dd");
        dateOfIssue = dateIssueFm.format(new Date());
        
        if(TKT_E){
            
            String strValue = "2012-02-19";
            java.util.Date  issueDate = null;
            java.util.Date  dateValue = null;

            try {
              issueDate= dateIssueFm.parse(dateOfIssue);
              dateValue = dateIssueFm.parse(strValue);
              if(issueDate.getTime()>= dateValue.getTime()){
                isIssue = true;
              }
            } catch (Exception e) {
              System.out.println("出票日期转换错误");
            }
            List orgList = ticket.getOrginalList();
            if(orgList != null && orgList.size()>0){
               Ticket ticket_old = (Ticket)ticket.getOrginalList().get(orgList.size()-1);
               String old_TicketNo = ticket_old.getTicketNumber();
               for(int i=orgList.size()-2;i>=0;i--){
                  Ticket ticketOld =(Ticket)orgList.get(i);
                  String oldTicketNo = ticketOld.getTicketNumber();
                  oldTicketNo = oldTicketNo.substring(oldTicketNo.length()-2,oldTicketNo.length());
                  old_TicketNo += "/"+oldTicketNo;
               }
               ticketNumber_old = "原票号 "+old_TicketNo;
            }
        }



        Passenger passenger = ticket.getPassenger();
        String psgName = passenger.getName();
        String certificateId = passenger.getCertificateId();
        if (psgName == null) {
          psgName = " ";
        }
        if (certificateId == null) {
          certificateId = " ";
        }

        //只有激光功能打印才会在纸张下面打印pnrCode,针式打印不需要;
        String pnrCode = " ";
        Vector reservations = ticket.getReservations();
        if (reservations != null) {
          for (int i = 0; i < reservations.size(); i++) {
            Reservation reservation = (Reservation) reservations.get(i);
            String companyId = reservation.getCompanyId();
            if(companyId == null){
              continue;
            }
            if (companyId.equals("CZ")) {
              pnrCode = reservation.getContrlNumber();
              break;
            }
          }
          for (int i = 0; i < reservations.size(); i++) {
            Reservation reservation = (Reservation) reservations.get(i);
            String companyId = reservation.getCompanyId();
            if(companyId == null){
              continue;
            }
            if (companyId.equals("1E")) {
              pnrCode = pnrCode + "/" + reservation.getContrlNumber();
              break;
            }
          }
          if (pnrCode == null) {
            pnrCode = " ";
          }
        }
        //只有激光功能打印才会在纸张下面打印orderNo,针式打印不需要;
        String orderNo = ticket.getOrderNo();
        if (orderNo == null) {
          orderNo = "";
        }

        IssuingAgent issuingAgent = ticket.getIssuingAgent();
        String iataCode = " ";
        boolean B2C = false;
        if(issuingAgent != null){
          if (issuingAgent.getIataCode() != null && issuingAgent.getIataCode().length() > 1){
            iataCode = issuingAgent.getIataCode();
          }
          //对B2C的客票，行程单上的填开单位显示“中国南方航空公司网站直销WWW.CSAIR.COM”。
          if(iataCode.equals("00001704") || issuingAgent.getAgentId().equals("B2COU")){
            issuedBy = "中国南方航空公司网站WWW.CSAIR.COM直销";
            B2C = true;
          }
        }
        
        double refundFare = 0;
        double refundAirportTax = 0;
        double refundFuelSurcharge = 0;
        double refundOtherFees = 0;
        double refundCoupons = 0;
        String repayStatus = "N";//部分退票标识
        
        PartlyRefundFees partlyRefundFees = ticket.getPartlyRefundFees();
         if (partlyRefundFees != null) {
							repayStatus = partlyRefundFees.getRepayStatus();         			
				 }      
        
        
        String airportTax = " ";
        String fuelTax = " ";
        String otherTax = " ";
        Vector taxs = ticket.getTaxs();
        float otherAmount = 0;
        float taxAmount = 0;
        float fuelAmount = 0;
        float bizFee = 0;
        String currency = "";
        String farePrice ="";
        float totalAmount = 0;
        String totalPrice = " ";
        String taxPrice = "";
        float cnTax = 0;
        float yqTax = 0;
        String cnCurrency ="";
        String yqCurrency = "";
        for(int t = 0; t < taxs.size(); t++) {
          Tax tax = (Tax)taxs.get(t);
          String code = tax.getCode();
          if (code == null) {
            code = "";
          }

          //如果有701是旧税（已交），700是新税  ,只能显示新税
          if(tax.getCategory() ==null || tax.getCategory().equals("700")){
             currency = tax.getCurrency();
             System.out.println("amount: " + tax.getAmount());
             if (code.equals("CN")) {
               taxAmount = tax.getAmount();
               cnTax = cnTax+ (float)taxAmount;
               cnCurrency = tax.getCurrency();
                continue;
             } else if (!TKT_I&& code.equals("YQ")) {
               fuelAmount = tax.getAmount();
               yqTax = yqTax + (float)fuelAmount;
               yqCurrency = tax.getCurrency();
               continue;
             }else if (TKT_I&& code.equals("YR")) {
               fuelAmount = tax.getAmount();
               yqTax = yqTax + (float)fuelAmount;
               yqCurrency = tax.getCurrency();
               continue;
             }  else {
               otherAmount = otherAmount + (float)tax.getAmount();
             }
          }
        }
//        //ECS的商旅费中也包含保险费...晕...不早说...只好在这里减去了 2008-06-17 by DSG LM;
//        //目前(2008-06-17)ECS的商旅费就只是保险费, 减去就行了;
//        if (ticket.getInsuranceFee() > 0) {
//          otherAmount = otherAmount - ticket.getInsuranceFee();
//        }
//        otherAmount = 0;


        //只有激光功能打印才会在纸张下面打印taxPrice,针式打印不需要;
         float totalTax = cnTax + yqTax + otherAmount;  //所有税费

         Fare fare = ticket.getFare();
         String fareType = fare.getFareType();
         //票价计算项
         String calStr = fare.getCalculationArea();
         String ogCurrency = fare.getOriginCurrency();
         if (ogCurrency == null) {
           ogCurrency = " ";
         }
         String finalCurrency = "";
         float  finalFare = 0;
         float finalTotal = 0;
         String fareCurrency = fare.getCurrency();
         String netFareCurrency = fare.getNetFareCurrency();
         if(TKT_I || "IT".equals(fareType)){
            totalAmount = (float)(fare.getNetFareAmount() + totalTax);
            if(netFareCurrency != null){
              finalCurrency = netFareCurrency;
              finalFare = (float)fare.getNetFareAmount();
              finalTotal =(float)totalAmount;
            }else{
              finalCurrency = fareCurrency;
              finalFare = (float)fare.getNetFareAmount();
              finalTotal =(float)totalAmount;
            }
         }else{
              finalCurrency = fareCurrency;
              finalFare = (float)fare.getFare();
              totalAmount = (float)(fare.getFare() + totalTax);
              finalTotal =(float)totalAmount;
         }
         if(TKT_E){
            if(isIssue){
              finalCurrency = netFareCurrency;
              finalFare = (float)fare.getNetFareAmount();
              finalTotal =(float)(fare.getNetFareAmount() + totalTax);
            }else{
              finalCurrency = fareCurrency;
              finalFare = (float)fare.getTicketAmount();
              finalTotal =(float)(fare.getTicketAmount() + totalTax);
            }
          }

					if ("Y".equals(repayStatus)) {
						System.out.println("repayStatus:" + repayStatus);
           	refundFare = partlyRefundFees.getRefundFare();
            refundAirportTax = partlyRefundFees.getRefundAirportTax();
            refundFuelSurcharge = partlyRefundFees.getRefundFuelSurcharge();
            refundOtherFees = partlyRefundFees.getRefundOtherFees();
            refundCoupons = partlyRefundFees.getRefundCoupons();           		
            		
            finalFare = (float) (finalFare - refundFare + refundCoupons);
          	finalTotal = (float) (finalTotal - refundFare - refundFuelSurcharge  - refundAirportTax - refundOtherFees + refundCoupons);
          	yqTax = (float) (yqTax - refundFuelSurcharge);
          	cnTax = (float) (cnTax - refundAirportTax);
          	otherAmount = (float) (otherAmount - refundOtherFees);
          	totalTax = cnTax + yqTax + otherAmount;
				}
				
          if(finalCurrency == null || finalCurrency.trim().length()==0){
            finalCurrency = "CNY";
          }
          
          farePrice = finalCurrency + " "+finalFare;
          totalPrice = finalCurrency +" "+ finalTotal;
                    
          
        /*
         * 以下逻辑处理优惠券
         * 2013-08-14
         */
         if(!TKT_E) {//只处理非换开票 2015-11-04
         		try {
          //从FC获取优惠券信息
          if (calStr != null && calStr.toUpperCase().indexOf("YHQ") != -1) {
            String txt = calStr.substring(calStr.toUpperCase().indexOf("YHQ")).substring(3);
            System.out.println("优惠券：" + txt);
            String yhqStr = txt + " ";
            /*
            * 解析优惠券
            */
						String[] cpnStrings = yhqStr.split("/");
						float cpnValues = 0;
						int cpnLength = cpnStrings.length;
						for (int v = 0; v < cpnLength; v++) {
							System.out.println("cpnString:" + cpnStrings[v]);
							String priceStr = cpnStrings[v].substring(10,13);
							int price = Integer.parseInt(priceStr);
							System.out.println("price:" + price);
							cpnValues += price;
						}
						System.out.println("cpnValues:" + cpnValues);
            
            finalFare = finalFare - cpnValues;
            finalTotal = finalTotal - cpnValues;
            
            farePrice = finalCurrency + " "+finalFare;
            totalPrice = finalCurrency +" "+ finalTotal;
            //System.out.println(fare);
            
          } else {
            System.out.println("FC中没有优惠券可以使用！");
          }                   
        } catch (Exception e) {
          e.printStackTrace();
        }
       }//----END 无优惠

				int cpnValue = 0;//新版优惠券
	      List promotionCodes =	ticket.getPromotionCodes();
				if (promotionCodes != null) {
						 for (int j = 0; j < promotionCodes.size(); j++) {
						 	 PromotionCode promotionCode = (PromotionCode)promotionCodes.get(j);
							 cpnValue += promotionCode.getAmount();
						 }
				}
				System.out.println("新版优惠券:" + cpnValue);
					
       /**
				 * 扣减新版优惠券价格
				 * */
				if (cpnValue > 0) {
					finalFare = finalFare - cpnValue;
          finalTotal = finalTotal - cpnValue;
          
          farePrice = finalCurrency + " "+finalFare;
          totalPrice = finalCurrency +" "+ finalTotal;
				}   
          
         if(cnTax >0){
           airportTax = finalCurrency + " " + (float)cnTax;
         }else{
           airportTax = finalCurrency + " 0.0";
         }
         if(yqTax >0){
           fuelTax = finalCurrency +" " + (float)yqTax;
         }else{
           fuelTax = finalCurrency +" 0.0";
         }
         if(otherAmount > 0) {
           otherTax = finalCurrency + " " + (float)(otherAmount);
         }else{
           otherTax = finalCurrency + " ";
         }
         taxPrice = finalCurrency + " " + (float)totalTax;  //货币单位+所有税费
         
         //打印保险费 2008-05-13 by DSG LM;
         //据ECS那边说保险费暂时都是人民币 2008-05-27 by DSG LM;
         String insuranceStr = " ";
         if (ticket.getInsuranceFee() > 0) {
           insuranceStr = "CNY " + (float)ticket.getInsuranceFee();
         }
         
          if(ticket.getTotalTickets() > 1 && ticket.getSequence()>1){
             farePrice = finalCurrency+ "  0.0";
             totalPrice = finalCurrency+ "  0.0";
            taxPrice = finalCurrency+ "  0.0";
             airportTax = finalCurrency+ "  0.0";
             fuelTax = finalCurrency+ "  0.0";
             otherTax= finalCurrency+ "  0.0";
             insuranceStr = "CNY " + "  0.0";
          }

         
         String dkStr = "";
         if(TKT_I){
            Vector payments = ticket.getPayments();
            
            if( payments.size() >0 ) {
              Payment payment = (Payment)payments.get(0);
              String freeText = payment.getFreeText();
              if(freeText != null && freeText.indexOf("DK") != -1) {
                  try{
                     dkStr = freeText.trim().substring(freeText.lastIndexOf("DK"), freeText.length());
                  }catch(Exception e) {
                     e.printStackTrace();
                  }
              }
            }
         }else {
          try{
            //从FC获取含有大客户号信息
            if(calStr != null && calStr.indexOf("DK") != -1){
              dkStr = calStr.trim().substring(calStr.lastIndexOf("DK"), calStr.length());
            }
          }catch(Exception e) {
            e.printStackTrace();
          }
        }
        if(dkStr != null && dkStr.length() ==9){
          dkStr = "大客户号:"+dkStr;
        }else{
          dkStr ="";
        }


        String flyerNo = ""; //明珠卡号

        //获取明珠卡号信息
        Vector flyers = passenger.getFrequentFlyers();
        if (flyers != null && flyers.size() > 0) {
          FrequentFlyer flyer = (FrequentFlyer)flyers.get(0);
          flyerNo = flyer.getFrequentFlyerNo();
          if (!flyerNo.equals("")){
            flyerNo = "明珠卡号:" + flyerNo;
          }
        }

        if (!flyerNo.equals("") && !dkStr.equals("")) {
          pnrCode = pnrCode + "  " + flyerNo + "/" + dkStr;
        } else {
          pnrCode =  pnrCode + "  " + flyerNo + dkStr;
        }
        if (pnrCode != null) {
          pnrCode = pnrCode.trim();
        }
        //以下开始为航段信息;
        Vector coupons = ticket.getCoupons();
        String fc = "";
        //很长的航段信息,只有激光打印才有;
        //针对缺口程的情况 2008-05-04 by DSG LM;
        //当时发现打印缺口程的时候航段显示问题;
        //原来的算法从没有改过,很奇怪一直没有人提出;
        Vector newCoupons = new Vector();
        int gapNum= 0;
        for (int z = 0; z < coupons.size(); z++) {
          Coupon coupon = (Coupon)coupons.get(z);
          int cNum = coupon.getCouponNumber();
          if (z > 0 && cNum != (z + gapNum +1)) {
            System.out.println("Found Gap");
            gapNum ++;
            Coupon addC = new Coupon();
            Flight addF = new Flight();

            Coupon nextC = (Coupon)coupons.get(z);
            Flight nextF = nextC.getFlight();
            String nextDep = nextF.getOriginAirport();

            addF.setDestinationAirport(nextDep);
            addF.setFlightNo("VOID");
            addC.setFlight(addF);
            addC.setFareBasis("缺口程");
            newCoupons.add(addC);
          }
          newCoupons.add(coupon);
        }

				
        String prompt="";
        //读取数据库机场停办手续
        SimpleDateFormat myFormatter = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date_new = null;
        java.util.Date date_old = null;
        java.util.Date today = null;
        String tdaye = java.text.DateFormat.getDateInstance().format(new java.util.Date());
        for (int y = 0; y < newCoupons.size(); y++) {
          Coupon coupon = (Coupon)newCoupons.get(y);
          Flight flight = coupon.getFlight();
          String depAirportNEW ="";
          Flging flgingAirpor = new Flging();
          try{
            if(flight.getOriginAirport() != null && !flight.getOriginAirport().equals("")){
              flgingAirpor = LocaleHelper.getCityMap(flight.getOriginAirport());
              if(flgingAirpor != null && !flgingAirpor.equals("") &&(flgingAirpor.getTestDate() != null && !flgingAirpor.getTestDate().equals("")) ){  //如果取的数据
           //   for(int a = 0 ;a <1 ;a ++){
                try {
                  today = myFormatter.parse(tdaye);
                  date_new =myFormatter.parse(flgingAirpor.getTestDate());
                  if(flgingAirpor.getSellDate() != null && !flgingAirpor.getSellDate().equals("")){
                    date_old = myFormatter.parse(flgingAirpor.getSellDate());
                  }
                } catch (Exception e) {
                  System.out.println("停办手续对比获取错误");
                }
                long day_new = date_new.getTime();
                long day = today.getTime();
                if(day >= day_new ){
                  if(flgingAirpor.getSellDate() != null){
                    long day_2 = date_old.getTime();
                    if(day_2 >= day){
                    }else{
                      break;
                    }
                  }
                }else{
                  break;
                }
                depAirportNEW =  flgingAirpor.getAerodromeName();
                if ( depAirportNEW == null) {
                  depAirportNEW = "";
                }

                if(depAirportNEW != null && !depAirportNEW.equals("")){
                  // 广长快线 广州-武汉 对航段信息CAN-CSX不进行45分钟提示  ???
             //     if( !(flight.getOriginAirport().equals("CAN")&&(flight.getDestinationAirport().equals("CSX") || flight.getDestinationAirport().equals("WUH")))){
                    if(prompt.equals("")){
                      prompt +=depAirportNEW + flgingAirpor.getInformationTime()+"分钟";
                    }else if(!prompt.equals("")&& prompt.indexOf(depAirportNEW) == -1){
                      prompt +=depAirportNEW + flgingAirpor.getInformationTime()+"分钟";
                    }
            //      }
                }
           //   }
            }
          }
         }catch (Exception ex) {
            ex.printStackTrace();
           System.out.println("停办手续获取错误："+ex);
         }
       }
       
       
       String remarkStr ="";
       
       /*
       if(!prompt.equals("")){
          remarkStr ="航班起飞前30分钟停办手续("+prompt+") 请认准南航网站www.csair.com、微信号CS95539和热线95539。";
       }else{
         remarkStr ="航班起飞前30分钟停办手续 请认准南航网站www.csair.com、微信号CS95539和热线95539。";
       }*/
       if(!prompt.equals("")){
          prompt = "（" + prompt + "）";
       }
       
       if(TKT_I) {
       		remarkStr ="请您至少提前60分钟" + prompt + "到达机场办理手续 请认准南航网站www.csair.com、微信号CS95539和热线95539。";
       }else {
       		remarkStr ="请您至少提前45分钟" + prompt + "到达机场办理手续 请认准南航网站www.csair.com、微信号CS95539和热线95539。";
       }
       String remark = "";
       String vflight = "";
       for (int j = 0; j < coupons.size(); j++) {

          Coupon coupon = (Coupon)coupons.get(j);

          Flight flight = coupon.getFlight();
          String carrier = flight.getCarrier();
          Date fdate = flight.getFlightDate();
          String flightNo = flight.getFlightNo();
					
					/*
          if("CZ".equals(carrier)&&("3000".equals(flightNo)||"3100".equals(flightNo)||"6000".equals(flightNo)||"6999".equals(flightNo))){
              remarkStr ="A380航班起飞前45分钟停办手续("+prompt+") 请认准南航网站www.csair.com、微信号CS95539和热线95539。";
          }
          */

          //2007-09-03 对西安出发的南航航班旅客给予提示 by DSG;
          //2008-03-27 对北京出发的南航航班旅客给予提示 by DSG LM;
          //2008-04-14 对上海出发的南航航班旅客给予提示 by DSG LM;
          //根据OC作判断;
	  String mc = flight.getMarketingCarrier();
	  String mcFlightNo = flight.getMarketingFlightNo();
          String depAirport = flight.getOriginAirport();
          String arrAirport = flight.getDestinationAirport();

          if("CZ".equals(carrier) && !"OPEN".equals(flightNo)&& !"VOID".equals(flightNo)&&fdate != null){
              boolean isVf = LocaleHelper.isVF(carrier+flightNo,depAirport,arrAirport,fdate);
              if(isVf)
                vflight+=carrier+flightNo;
          }
       }
       if(ticketNumber_old!= null && !"".equals(ticketNumber_old)){
          cknTkt = ticketNumber_old;
       }
       if(vflight != null && !"".equals(vflight)){
         cknTkt =vflight+"为地面运输南航免责" ;
       }
       System.out.println(ticketNumber + " " + farePrice + " " +airportTax+ " " +fuelTax + " " +totalPrice);
        //remarkStr = "航班起飞前30分钟停办手续(上海乌鲁木齐各机场45分钟) 验证网址:www.csair.com 验证电话:95539";
        %>
        
        <%
        
				//定义数据节点
				Element data = ticketdata.addElement("ticket");
				
				//政府机票
				Element officialTicket = data.addElement("gp");
				//旅客姓名	
				Element person = data.addElement("psgName");				
				//有效身份证证件号
				Element tourCode = data.addElement("certificateId");
				//签注
				Element restrictions = data.addElement("endorsements");
				//票价
				Element tktFare = data.addElement("farePrice");
				//机场建设费
				Element airTax = data.addElement("airportTax");
				//燃油附加费
				Element fueTax = data.addElement("fuelTax");
				//其它税费
				Element othTax = data.addElement("otherTax");
				//合计
				Element totPrice = data.addElement("totalPrice");
				//电子客票号码
				Element ticketNum = data.addElement("ticketNum");
				//验证码
				Element ck = data.addElement("validateCode");
				//连续客票
				Element conjunctTkt = data.addElement("cknTkt");
				//保险费
				Element insuranceFee = data.addElement("insuranceStr");
				//销售单位代号
				Element agentCode = data.addElement("iataCode");
				//填开单位
				Element agent = data.addElement("issuedBy");
				//填开日期
				Element issueDate = data.addElement("dateOfIssue");
				//自
				Element depcity1 = data.addElement("depcity1");
				//至(1)
				Element depcity2 = data.addElement("depcity2");
				//至(2)
				Element depcity3 = data.addElement("depcity3");
				//至(3)
				Element depcity4 = data.addElement("depcity4");
				//至(4)
				Element depcity5 = data.addElement("depcity5");
				//承运人(1)
				Element carrier1 = data.addElement("carrier1");
				//承运人(2)
				Element carrier2 = data.addElement("carrier2");
				//承运人(3)
				Element carrier3 = data.addElement("carrier3");
				//承运人(4)
				Element carrier4 = data.addElement("carrier4");
				//航班号(1)
				Element flt1 = data.addElement("flight1");
				//航班号(2)
				Element flt2 = data.addElement("flight2");
				//航班号(3)
				Element flt3 = data.addElement("flight3");
				//航班号(4)
				Element flt4 = data.addElement("flight4");
				//座位等级(1)
				Element class1 = data.addElement("class1");
				//座位等级(2)
				Element class2 = data.addElement("class2");
				//座位等级(3)
				Element class3 = data.addElement("class3");
				//座位等级(4)
				Element class4 = data.addElement("class4");
				//日期(1)
				Element dater1 = data.addElement("date1");
				//日期(2)
				Element dater2 = data.addElement("date2");
				//日期(3)
				Element dater3 = data.addElement("date3");
				//日期(4)
				Element dater4 = data.addElement("date4");
				//时间(1) 不传值
				Element timer1 = data.addElement("time1");
				//时间(2)
				Element timer2 = data.addElement("time2");
				//时间(3)
				Element timer3 = data.addElement("time3");
				//时间(4)
				Element timer4 = data.addElement("time4");
				//客票级别/客票类别(1)
				Element fareBase1 = data.addElement("fareBasis1");
				//客票级别/客票类别(2)
				Element fareBase2 = data.addElement("fareBasis2");
				//客票级别/客票类别(3)
				Element fareBase3 = data.addElement("fareBasis3");
				//客票级别/客票类别(4)
				Element fareBase4 = data.addElement("fareBasis4");
				//客票生效日期(1)
				Element nvb1 = data.addElement("nvb1");
				//客票生效日期(2)
				Element nvb2 = data.addElement("nvb2");
				//客票生效日期(3)
				Element nvb3 = data.addElement("nvb3");
				//客票生效日期(4)
				Element nvb4 = data.addElement("nvb4");
				//客票截止日期(1)
				Element nva1 = data.addElement("nva1");
				//客票截止日期(2)
				Element nva2 = data.addElement("nva2");
				//客票截止日期(3)
				Element nva3 = data.addElement("nva3");
				//客票截止日期(4)
				Element nva4 = data.addElement("nva4");
				//免费行李(1)
				Element allow1 = data.addElement("allow1");
				//免费行李(2)
				Element allow2 = data.addElement("allow2");
				//免费行李(3)
				Element allow3 = data.addElement("allow3");
				//免费行李(4)
				Element allow4 = data.addElement("allow4");
				//以下为附联内容
				//旅客姓名
				Element nameOfPsg = data.addElement("name");
				//订单编号
				Element orderNumber = data.addElement("orderNo");
				//订座编码
				Element reservCode = data.addElement("pnrCode");
				//票价
				Element tktFee = data.addElement("totalFare");
				//税款
				Element totalFee = data.addElement("totalTax");
				//总价
				Element tktPrice = data.addElement("price");
				//票号(附联)
				Element tktNo = data.addElement("tktNo");
				//航段
				Element segments = data.addElement("fc");
				//备注
				Element remarker = data.addElement("remark");
				//二维码图片
				//Element twoDCode = data.addElement("twoDCode");
				//twoDCode.setText("http://www.baidu.com/img/baidu_jgylogo3.gif");
				//文本：旅客姓名
				Element txtName = data.addElement("txtName");
				txtName.setText("旅客姓名:");
				//文本：订单编号
				Element txtOrderNo = data.addElement("txtOrderNo");
				txtOrderNo.setText("订单编号:");
				//文本：订座编码
				Element txtPnrCode = data.addElement("txtPnrCode");
				txtPnrCode.setText("订座编码:");
				//文本：票价
				Element txtPrice = data.addElement("txtPrice");
				txtPrice.setText("票价:");
				//文本：税款
				Element txtTax = data.addElement("txtTax");
				txtTax.setText("税款:");
				//文本：总价
				Element txtTotalPrice = data.addElement("txtTotalPrice");
				txtTotalPrice.setText("总价:");
				//文本：票号(附联)
				Element txtTicket = data.addElement("txtTicket");
				txtTicket.setText("票号:");
				//文本：航段
				Element txtFc = data.addElement("txtFc");
				txtFc.setText("航段:");
				//文本：备注
				Element txtRemark = data.addElement("txtRemark");
				txtRemark.setText("备注:");
				//文本：提示
				Element txtWeb = data.addElement("txtWeb");
				txtWeb.setText("尊敬的旅客：您每乘坐一次南航航班，南航就捐出“10分”钱注入南航“十分”关爱基金，用于慈善公益事业。  一次飞行  十分关爱");
				
				Element rightTip01 = data.addElement("rightTip01");
				rightTip01.setText("南航首家推出短信呼叫一码通，发送");
				
				Element rightTip02 = data.addElement("rightTip02");
				rightTip02.setText("短信“？”到95539，即可享受航班起");
				
				Element rightTip03 = data.addElement("rightTip03");
				rightTip03.setText("降时刻、优惠票价、机票验真等服务");
        %>
        
        
        i = i + 1;
        
        <%
        officialTicket.setText(gp);//政府机票
        person.setText(psgName);//姓名
        restrictions.setText(endorsements);//签注
        tourCode.setText(certificateId);//证件号       
        //票价
				tktFare.setText(farePrice);
				//机场建设费
				airTax.setText(airportTax);        
				//燃油附加费
				fueTax.setText(fuelTax);          
				//其它税费
				othTax.setText(otherTax);        
				//合计
				totPrice.setText(totalPrice);       
				//电子客票号码
				ticketNum.setText(ticketNo);        
				//验证码
				ck.setText(validateCode);      
				//连续客票
				conjunctTkt.setText(cknTkt);        
				//保险费
				insuranceFee.setText(insuranceStr);
				//销售单位代号
				agentCode.setText(iataCode);
				//填开单位
				agent.setText(issuedBy);
				//填开日期
				issueDate.setText(dateOfIssue);
				//以下为附联内容
        //旅客姓名
				nameOfPsg.setText(psgName);        
				//订单编号
				orderNumber.setText(orderNo); 
				//订座编码
				reservCode.setText(pnrCode); 
				//票价
				tktPrice.setText(farePrice); 				
				//税款
				totalFee.setText(taxPrice); 
				//总价
				tktFee.setText(totalPrice); 
				//票号(附联)
				tktNo.setText(ticketNo); 
				//航段
				segments.setText(fc); 
				//备注
				remarker.setText(remarkStr); 
        %>
        

        <%
        CityCodeDAO cityCodeDAO = new CityCodeDAO();
        for (int m = 0; m < newCoupons.size(); m++) {
          Coupon coupon = (Coupon)newCoupons.get(m);
          String status = coupon.getStatus();
          String fareBasis = coupon.getFareBasis();
          String allowBaggage = coupon.getAllowBaggage();
          Flight flight = coupon.getFlight();
          String carrier = flight.getCarrier();
          String flightNo = flight.getFlightNo();
          String mc = flight.getMarketingCarrier();
          String mcFlightNo = flight.getMarketingFlightNo();
          String flightClass = flight.getFlightClass();
          String depAirport = flight.getOriginAirport();
          String arrAirport = flight.getDestinationAirport();
          if (depAirport == null) {
            depAirport = " ";
          }
          if (arrAirport == null) {
            arrAirport = " ";
          }
          
          System.out.println("舱位 " + flightClass );
          //F -> C  2013-06-24
          String f2cFlag =  passenger.getEirPrintClass();
          System.out.println("f2cFlag " + f2cFlag );
          if(f2cFlag != null && carrier != null) {   
          	//System.out.println("我在这里！ ");
          	if(F2C == null) {
          		System.out.println("F2C ERROR，检查配置表！");
          	}          	
          	         	
          	if(Pricing != null && Pricing.getInternationalsale() != null && F2C != null && flightClass != null && !"".equals(Pricing) && Pricing.getInternationalsale().equals("D") && carrier.toUpperCase().equals("CZ") && F2C.indexOf(flightClass.toUpperCase())!= -1) {
          	
            	System.out.print("舱位由 " + flightClass + "变为 ");
            	
            		flightClass = f2cFlag;
            	
            	
            	System.out.println(flightClass + "。");
          	}
          }
          
          
          //获取机场名称,增加对国际行程单名称的支持

          String depAirportCn =" ";
          String arrAirportCn =" ";
          ParCityAirCode parCityAirCode = null;
          if((Pricing != null && Pricing.getInternationalsale() != null && Pricing.getInternationalsale().equals("I"))||Pricing == null){
          //如果为国际票
             try{
               parCityAirCode = cityCodeDAO.findByTicketNo(depAirport);
             }catch (Exception ex) {
               System.out.println("读取机场名称错误："+ex);
             }
             if (parCityAirCode == null) {
               depAirportCn = " ";
             }else{
               depAirportCn= parCityAirCode.getCityId();
             }

             ParCityAirCode cityCode = null;
             try{
                cityCode = cityCodeDAO.findByTicketNo(arrAirport);
             }catch (Exception ex) {
                System.out.println("读取机场名称错误："+ex);
             }
             if (cityCode == null) {
                arrAirportCn = " ";
             }else{
                arrAirportCn= cityCode.getCityId();
             }
          } else {
             depAirportCn = LocaleHelper.getCityId(depAirport, session.getServletContext());
             if (depAirportCn == null) {
                depAirportCn = " ";
              }
             arrAirportCn = LocaleHelper.getCityId(arrAirport, session.getServletContext());
             if (arrAirportCn == null) {
               arrAirportCn = " ";
             }
          }
          if(depAirportCn.length() > 16 || depAirportCn.length() < 2){
             depAirportCn = " ";
          }else {
             depAirportCn +="/";
          }

          if(arrAirportCn.length() > 16 || arrAirportCn.length() < 2){
             arrAirportCn = " ";
          }else {
             arrAirportCn +="/";
          }

          String departureTime = flight.getDepartureTime();
          if(departureTime!=null&&departureTime.length()==4){
             departureTime = departureTime.substring(0,2)+":"+departureTime.substring(2,4);
          }
          String flightDate = " ";
          String flightDate2 = " ";
          String validateBefore = " ";
          String validateAfter = " ";
          Locale locale = new Locale("EN");
          SimpleDateFormat f1 = new SimpleDateFormat("yyyy-MM-dd");
          SimpleDateFormat f2 = new SimpleDateFormat("ddMMM", locale);
          f1.setLenient(false);
          f2.setLenient(false);
          if (flight.getFlightDate() != null){
            if(TKT_I){
                flightDate = f2.format(flight.getFlightDate()).toUpperCase();
             }else{
                flightDate = f1.format(flight.getFlightDate()).toUpperCase();
             }
          }
          if (coupon.getNotValidBefore() != null){
            validateBefore = f1.format(coupon.getNotValidBefore()).toUpperCase();
          }
          if (coupon.getNotValidAfter() != null){
            validateAfter = f1.format(coupon.getNotValidAfter()).toUpperCase();
          }
          if (carrier == null){
            carrier = " ";
          }
          if (flightNo == null){
            flightNo = " ";
          }
          //有MC才显示MC信息;
          if (mc == null || mc.trim().equals("")){
            mc = carrier;
            mcFlightNo = flightNo;
          }
          if (mcFlightNo == null){
            mcFlightNo = " ";
          }
          if (flightClass == null){
            flightClass = " ";
          }
          if (fareBasis == null){
            fareBasis = " ";
          }
          if (flightDate == null){
            flightDate = " ";
          }
          if (flightDate2 == null){
            flightDate2 = " ";
          }
          if(departureTime == null){
            departureTime = "    ";
          }
          if (allowBaggage == null){
            allowBaggage = " ";
          }
          if(validateBefore == null){
            validateBefore = " ";
          }
          if (validateAfter == null){
            validateAfter = " ";
          }
          //要求取消 生效日期，截止日期  hyzh 2009-8-27
          validateAfter ="";
          validateBefore = "";
          //2007-09-03 对西安出发的南航航班旅客给予提示 by DSG;
          //2008-03-27 对北京出发的南航航班旅客给予提示 by DSG LM;
          //2008-04-14 对上海出发的南航航班旅客给予提示 by DSG LM;
          //根据OC作判断;
          String tRemark = "";
          String boardNo = "";          

          boolean isInternational = false;
          boolean isDomestic = false;

          String domesticCityPair = TicketConfig.getValue("domesticCityPair");
          String internationalCityPair = TicketConfig.getValue("internationalCityPair");

          if (carrier.equals("CZ")) {
	    			Terminal originTerminal = null;
	    			Terminal destionTerminal = null;
            if(TKT_I){
               originTerminal = LocaleHelper.getTerminal(flight,"I",true);
               //destionTerminal = LocaleHelper.getTerminal(flight,"I",false);
            }else{
               originTerminal = LocaleHelper.getTerminal(flight,"D",true);
               //destionTerminal = LocaleHelper.getTerminal(flight,"I",false);
            }
            if(originTerminal != null){
               tRemark = originTerminal.getOriginTerminal()+"登机";
               boardNo = originTerminal.getDestionTerminal()+"到达";
             }
             //if(destionTerminal != null){
             //   boardNo = destionTerminal.getDestionTerminal()+"到达";
             //}
	   			} else if (carrier.equals("MU")) {
	            //2008-06-13 对西安出发的东航航班旅客给予提示 by DSG LM;
	       		if (depAirport.equals("XIY") || depAirport.equals("XIA")) {
	           tRemark = "T2登机";
	        	}
	            //2009-11-18 对PVG出发的东航航班旅客给予提示 hyzh;
	       if (depAirport.equals("PVG")) {
	           tRemark = "T1登机";
	       }
	       if("CZ".equals(mc) && depAirport.equals("SHA")){
	           tRemark = "虹桥T2登机";
	       }
	   } else if (carrier.equals("JL")){
	          //2008-08-21 对JL的航班，从北京出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("PEK")){
	           tRemark = "T3登机";
	       }
	   } else if (carrier.equals("3U")){
	            //2008-08-21 对3U的航班，从成都出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("CTU")){
	           tRemark = "T2登机";
	       }
	   }else if (carrier.equals("MF")){
	            //2009-11-18 对MF的航班，从PEK出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("PEK")){
	           tRemark = "T2登机";
	       }
	            //2009-11-18 对MF的航班，从KUL出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("KUL")){
	           tRemark = "M登机";
	       }
	            //2009-11-18 对MF的航班，从WUH出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("WUH")){
	           tRemark = "T2登机";
	       }
	            //2009-11-18 对MF的航班，从XIY出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("XIY")){
	           tRemark = "T3登机";
	       }
	            //2009-11-18 对MF的航班，从SIN出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("SIN")){
	           tRemark = "T1登机";
	       }
	            //2009-11-18 对MF的航班，从NRT出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("NRT")){
	           tRemark = "T2登机";
	       }
	            //2009-11-18 对MF的航班，从HKG出发的南航旅客给予提示 BY HYZH
	       if(depAirport.equals("HKG")){
	           tRemark = "T1登机";
	        }
	   }else if(carrier.equals("MH")) {
            /**
             * 由于MH在北京机场将于3月1日起将转场到T3航站楼，需求修改CZ/MH代码共享航班在行程单上的始发/到达航站楼提示信息。2013-3-26
             * 修改CZ/MH北京始发航班行程单上的始发航站楼信息为T3，具体航班号为：CZ4051/CZ749/CZ747
             * 修改CZ/MH北京到达航班行程单上的到达航站楼信息为T3，具体航班号为：CZ4052/CZ750/CZ748
             */
            if(depAirport.equals("PEK") ) {
              tRemark = "T3登机";
            }
            if(arrAirport.equals("PEK")) {
              tRemark = "T3到达";
            }
          }
          
          if(boardNo == null ||"".equals(boardNo)){
             boardNo = " ";
          }

					

					if(m == 0) {
						if("R".equals(status)){
							fc = fc + depAirportCn;
							depcity1.setText("VOID");
							depcity2.setText("");
							carrier1.setText("");
						
							flt1.setText("VOID"); 
							class1.setText("");
							dater1.setText(" ");
							timer1.setText("");
							fareBase1.setText(" ");
							nvb1.setText("");
							nva1.setText("");
							allow1.setText("");
						}else{
							fc = fc + depAirportCn;
							depcity1.setText(depAirportCn+depAirport);
							depcity2.setText(arrAirportCn+arrAirport+boardNo);
							carrier1.setText(mc);
						
							flt1.setText(mcFlightNo); 
							class1.setText(flightClass);
							dater1.setText(flightDate + " " + departureTime);
							timer1.setText("");
							fareBase1.setText(fareBasis + " " + tRemark);
							nvb1.setText(validateBefore);
							nva1.setText(validateAfter);
							allow1.setText(allowBaggage);
						}						
					}
					
					if(m == 1) {
						if("R".equals(status)) {
							depcity3.setText("VOID");
							carrier2.setText("");
						
							flt2.setText("VOID"); 
							class2.setText("");
							dater2.setText(" ");
							timer2.setText("");
							fareBase2.setText(" ");
							nvb2.setText("");
							nva2.setText("");
							allow2.setText("");
						}else{
							depcity3.setText(arrAirportCn+arrAirport+boardNo);
							carrier2.setText(mc);
						
							flt2.setText(mcFlightNo); 
							class2.setText(flightClass);
							dater2.setText(flightDate + " " + departureTime);
							timer2.setText("");
							fareBase2.setText(fareBasis + " " + tRemark);
							nvb2.setText(validateBefore);
							nva2.setText(validateAfter);
							allow2.setText(allowBaggage);	
						}												
					}
					
					if(m == 2) {
						if("R".equals(status)){
							depcity4.setText("VOID");
							carrier3.setText("");
						
							flt3.setText("VOID"); 
							class3.setText("");
							dater3.setText(" ");
							timer3.setText("");
							fareBase3.setText(" ");
							nvb3.setText("");
							nva3.setText("");
							allow3.setText("");
						}else{
							depcity4.setText(arrAirportCn+arrAirport+boardNo);
							carrier3.setText(mc);
						
							flt3.setText(mcFlightNo); 
							class3.setText(flightClass);
							dater3.setText(flightDate + " " + departureTime);
							timer3.setText("");
							fareBase3.setText(fareBasis + " " + tRemark);
							nvb3.setText(validateBefore);
							nva3.setText(validateAfter);
							allow3.setText(allowBaggage);	
						}						
						
					}
					
					if(m == 3) {	
				    if("R".equals(status)){
				    	depcity5.setText("VOID");
							carrier4.setText("");
						
							flt4.setText("VOID"); 
							class4.setText("");
							dater4.setText(" ");
							timer4.setText("");
							fareBase4.setText(" ");
							nvb4.setText("");
							nva4.setText("");
							allow4.setText("");
				    }else{
				    	depcity5.setText(arrAirportCn+arrAirport+boardNo);
							carrier4.setText(mc);
						
							flt4.setText(mcFlightNo); 
							class4.setText(flightClass);
							dater4.setText(flightDate + " " + departureTime);
							timer4.setText("");
							fareBase4.setText(fareBasis + " " + tRemark);
							nvb4.setText(validateBefore);
							nva4.setText(validateAfter);
							allow4.setText(allowBaggage);
				    }											
					}
          
          if (fareBasis != null && fareBasis.equals("缺口程")) {
            fc = fc + " " + mcFlightNo + " "  + arrAirportCn;
          } else if(!"R".equals(status)){
            fc = fc + " " + mc + mcFlightNo + "/" + flightDate + "/" + flightClass + " " + arrAirportCn;
          }

          if(!TKT_I){
            String mcCN = TicketConfig.getValue(mc);
             if(mcCN != null){
                mcFlightNo = mc+ mcFlightNo;
                mc = mcCN;
             }
          }

          if (status != null && status.equals("R")) {//2007-02-05 by DSG;
            flightNo = "已退票";
          }

        }//for coupon.size() END;
        for(int n = newCoupons.size(); n < 4; n++) {
        //如果不足4个航段,用"VOID"占格;                  
          if(n == 1) {						
						depcity3.setText("VOID");
						carrier2.setText(" ");
						
						flt2.setText("VOID"); 
						class2.setText(" ");
						dater2.setText(" ");
						timer2.setText("");
						fareBase2.setText(" ");
						nvb2.setText(" ");
						nva2.setText(" ");
						allow2.setText(" ");
					}
          
          if(n == 2) {						
						depcity4.setText("VOID");
						carrier3.setText(" ");
						
						flt3.setText("VOID"); 
						class3.setText(" ");
						dater3.setText(" ");
						timer3.setText("");
						fareBase3.setText(" ");
						nvb3.setText(" ");
						nva3.setText(" ");
						allow3.setText(" ");
					}
					
					if(n == 3) {						
						depcity5.setText("VOID");
						carrier4.setText(" ");
						
						flt4.setText("VOID"); 
						class4.setText(" ");
						dater4.setText(" ");
						timer4.setText("");
						fareBase4.setText(" ");
						nvb4.setText(" ");
						nva4.setText(" ");
						allow4.setText(" ");
					}          
         
        }
        //以上为航段部分的信息;

        //只有激光打印才有fc信息;
        segments.setText(fc);//航段       

      }//if(ticket != null) END;
		
    }//for printList.size() END;
    %>

    <%
    String xmlData = null;
    if(doc != null) {
    	if(doc.getRootElement() != null) {
    		xmlData = doc.getRootElement().asXML();
    	}  	
    }
    
    System.out.println("xmlData:" + xmlData);//print test
    if (printList.size() > 0) {
    	System.out.println("before");
    %>

    	var printTicket = document.getElementById("printTicket");   
    	//加载模板

    	printTicket.setDefind("https://eir.csair.com/Manage/format.xml");
    	//加载数据

			printTicket.setDataXML("<%=xmlData%>");

			//打印票据
			printTicket.printData();

      
    <%
    	System.out.println("after");
    }
    %>

  } catch(e) {

    if(confirm("凭证打印控件初始化错误，请确认您安装了控件。如果您安装了控件，那么请确认您没有禁用ACTIVE控件，然后重新做一遍。")){
    	window.location = "help/newPluginTips.html";
    }else{
    	return false;
    }
  }
  return true;
}
</SCRIPT>
</HEAD>
<BODY onload="return window_onload()">
<br>
<%
  int seq = 0;
  for (int i = 0; i < receiptList.size(); i++) {
    TicketReceipt ticketReceipt = (TicketReceipt) receiptList.get(i);
    String str1 = "票号为" + ticketReceipt.getTicketNumber() + "，"; ;
    String str2 = "";
    String str3 = "";
    if (ticketReceipt.getReceiptNumber() != null) {
      str2 = "行程单号为" + ticketReceipt.getReceiptNumber() + "的行程单，";
      str3 = "       <span onclick=repeat(" + seq + ")><a href='#'>重复打印</a></span>";
      seq++;
    }
    out.println(str1 + str2 + ticketReceipt.getRemark() + str3 + "<br>");
  }
%>
<form method="post" name="frm" action="">
<input type="button" name="button" onclick="goBack();" value="返 回" class="button"/>

<br>
<br>
</form>

<div align=center  style="display:none">
	<OBJECT id="printTicket" classid="clsid:5506D9F0-6BAF-46DA-AAC0-956FFD98CCB6" 
		codeBase="http://eir.csair.com/Manage/ticketprint/PrintTicket.cab#Version=1,2,0,6" >
	</OBJECT>
</div>


<script language="javascript" type="text/javascript">
function repeat(seq){
  if (!confirm("您确定要重复打印行程单吗？"))
     return false;
  window.location.href = "laserPrint.jsp?seq=" + seq;
}
function goBack() {

  window.location.href = "javascript:history.back(-1);";
}



</script>
</BODY>
</HTML>
