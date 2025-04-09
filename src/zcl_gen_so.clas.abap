class ZCL_GEN_SO definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
      INTERFACES if_oo_adt_classrun .

  METHODS saveOrder
    IMPORTING
      VALUE(body) TYPE string
    RETURNING
        VALUE(response) TYPE string.

  METHODS getCID RETURNING VALUE(cid) TYPE abp_behv_cid.

protected section.
private section.
ENDCLASS.



CLASS ZCL_GEN_SO IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

    DATA: lv_response TYPE string.

    CASE request->get_method( ).
        WHEN CONV string( if_web_http_client=>post ).
            " Handle POST request
            lv_response = saveOrder( request->get_text( ) ).
            response->set_status( 200 ).
            response->set_text( lv_response ).

        WHEN OTHERS.
            " Handle other HTTP methods
            lv_response = 'Unsupported HTTP method'.
            response->set_status( 405 ).
            response->set_text( lv_response ).
    ENDCASE.

  endmethod.

  METHOD saveOrder.

    TYPES: BEGIN OF ty_requested_quantity,
             content TYPE i,
             uomCode TYPE string,
           END OF ty_requested_quantity.

    TYPES: BEGIN OF ty_item,
             lineNumber        TYPE string,
             description       TYPE string,
             productDisplayId  TYPE string,
             requestedQuantity TYPE ty_requested_quantity,
           END OF ty_item.

    TYPES: tt_items TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY.

*        TYPES: BEGIN OF ty_partner,
*                 displayId TYPE string,
*                 role      TYPE string,
*               END OF ty_partner.

*        TYPES: tt_partners TYPE STANDARD TABLE OF ty_partner WITH EMPTY KEY.

    TYPES: BEGIN OF ty_extensions,
             SampleOwner  TYPE string,
             SalesPhase   TYPE string,
             FollowUpDate TYPE string,
           END OF ty_extensions.

    TYPES: BEGIN OF ty_body,
             id                         TYPE string,
             displayId                  TYPE string,
             name                       TYPE string,
             documentType               TYPE string,
             documentDate               TYPE string,
             documentCurrency           TYPE string,
             salesOrganizationDisplayId TYPE string,
             distributionChannel        TYPE string,
             division                   TYPE string,
             accountDisplayId           TYPE string,
*                 partners                       TYPE tt_partners,
             items                      TYPE tt_items,
             extensions                 TYPE ty_extensions,
           END OF ty_body.

    TYPES: BEGIN OF ty_message_header,
             id                        TYPE string,
             creationDateTime          TYPE string,
             actionCode                TYPE string,
             referenceMessageRequestId TYPE string,
           END OF ty_message_header.

    TYPES: BEGIN OF ty_message_request,
             messageHeader TYPE ty_message_header,
             body          TYPE ty_body,
           END OF ty_message_request.

    TYPES: tt_message_requests TYPE STANDARD TABLE OF ty_message_request WITH EMPTY KEY.

    TYPES: BEGIN OF ty_json_root,
             messageRequests TYPE tt_message_requests,
           END OF ty_json_root.

    DATA lv_message TYPE ty_json_root.

    DATA: lv_order TYPE zr_salesorder_hdr,
          lv_items TYPE TABLE OF zr_salesorder_line,
          wa_items TYPE zr_salesorder_line.


*    DATA: lv_order TYPE zsalesorder_hdr,
*          lv_items TYPE TABLE OF zsalesorder_line,
*          wa_items TYPE zsalesorder_line.

    xco_cp_json=>data->from_string( body )->write_to( REF #( lv_message ) ).

    LOOP AT lv_message-messageRequests INTO DATA(ls_message).

      lv_order-Displayid = ls_message-body-displayId.
      lv_order-Id = ls_message-body-id.
      lv_order-DocumentType = ls_message-body-documentType.

      REPLACE ALL OCCURRENCES OF '-' IN ls_message-body-documentDate WITH ''.
      lv_order-DocumentDate = ls_message-body-documentDate.
      lv_order-DocumentCurrency = ls_message-body-documentCurrency.
      lv_order-Salesorganization = ls_message-body-salesOrganizationDisplayId.
      lv_order-DistributionChannel = ls_message-body-distributionChannel.
      lv_order-Division = ls_message-body-division.
      lv_order-Customer = ls_message-body-accountDisplayId.
      lv_order-Name = ls_message-body-name.
      lv_order-Salesphase = ls_message-body-extensions-SalesPhase.
      lv_order-Sampleowner = ls_message-body-extensions-sampleowner.

*      MODIFY zsalesorder_hdr FROM @lv_order.
      LOOP AT ls_message-body-items INTO DATA(ls_item).
        wa_items-Displayid = lv_order-Displayid.
        wa_items-Product = ls_item-productDisplayId.
        wa_items-Description = ls_item-description.
        wa_items-LineNumber = ls_item-lineNumber.
        wa_items-RequestedQuantity = ls_item-requestedQuantity-content.
        wa_items-Uom = ls_item-requestedQuantity-uomCode.

*        INSERT zsalesorder_line FROM @wa_items.
        APPEND wa_items TO lv_items.
        CLEAR wa_items.
      ENDLOOP.



      DATA(cid) = getCID( ).

      MODIFY ENTITIES OF zr_salesorder_hdr
      ENTITY ZrSalesorderHdr
      CREATE FIELDS (
        Id
        Displayid
        DocumentType
        DocumentDate
        DocumentCurrency
        Salesorganization
        DistributionChannel
        Division
        Customer
        Name
        Salesphase
        Sampleowner )

        WITH VALUE #( (
          %cid = cid
          Id = lv_order-Id
          Displayid = lv_order-Displayid
          DocumentType = lv_order-DocumentType
          DocumentDate = lv_order-DocumentDate
          DocumentCurrency = lv_order-DocumentCurrency
          Salesorganization = lv_order-Salesorganization
          DistributionChannel = lv_order-DistributionChannel
          Division = lv_order-Division
          Customer = lv_order-Customer
          Name = lv_order-Name
          Salesphase = lv_order-Salesphase
          Sampleowner = lv_order-Sampleowner
       ) )
      CREATE BY \_Items
      FIELDS (
        Displayid
        Product
        Description
        LineNumber
        RequestedQuantity
        Uom )
        WITH VALUE #( ( %cid_ref = cid
                      %target = VALUE #( FOR wv_items IN lv_items INDEX INTO i (
                            %cid =  |{ cid }{ i WIDTH = 3 ALIGN = RIGHT PAD = '0' }|
                            Displayid = wv_items-Displayid
                            Description = wv_items-Description
                            LineNumber = wv_items-LineNumber
                            RequestedQuantity = wv_items-RequestedQuantity
                            Uom = wv_items-Uom
                            Product = wv_items-Product
                        ) )
                     ) )
       REPORTED DATA(ls_po_reported)
        FAILED   DATA(ls_po_failed)
        MAPPED   DATA(ls_po_mapped).

      COMMIT ENTITIES BEGIN
         RESPONSE OF zr_salesorder_hdr
         FAILED DATA(lt_commit_failed)
         REPORTED DATA(lt_commit_reported).
      ...
      COMMIT ENTITIES END.


    ENDLOOP.



    response = 'Order saved successfully'.


  ENDMETHOD.

     METHOD getCID.
            TRY.
                cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
                ASSERT 1 = 0.
            ENDTRY.
      ENDMETHOD.

     METHOD IF_OO_ADT_CLASSRUN~main.
        DELETE FROM zsalesorder_hdr.
        DELETE FROM zsalesorder_line.

     ENDMETHOD.
ENDCLASS.
