unit uFMMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, iocpTcpServer, StdCtrls, ExtCtrls, uRunTimeINfoTools;

type
  TFMMonitor = class(TFrame)
    Label1: TLabel;
    tmrReader: TTimer;
    lblsvrState: TLabel;
    lblRecv: TLabel;
    lblPostRecvINfo: TLabel;
    Label3: TLabel;
    lblSend: TLabel;
    Label4: TLabel;
    lblAcceptEx: TLabel;
    lblOnlineCounter: TLabel;
    Label5: TLabel;
    lblRunTimeINfo: TLabel;
    Label6: TLabel;
    lblWorkerCount: TLabel;
    Label7: TLabel;
    lblRecvdSize: TLabel;
    lblSentSize: TLabel;
    lblSendQueue: TLabel;
    Label8: TLabel;
    lblSocketHandle: TLabel;
    lblSocketHandleCaption: TLabel;
    lblContextInfo: TLabel;
    Label2: TLabel;
    lblSendRequest: TLabel;
    Label10: TLabel;
    procedure lblRecvDblClick(Sender: TObject);
    procedure lblWorkerCountClick(Sender: TObject);
    procedure tmrReaderTimer(Sender: TObject);
    procedure refreshState;
  private
    FIocpTcpServer: TIocpTcpServer;
    { Private declarations }
  public
    class function createAsChild(pvParent: TWinControl; pvIOCPTcpServer:
        TIocpTcpServer): TFMMonitor;
    property IocpTcpServer: TIocpTcpServer read FIocpTcpServer write FIocpTcpServer;
  end;

implementation

{$R *.dfm}

class function TFMMonitor.createAsChild(pvParent: TWinControl; pvIOCPTcpServer:
    TIocpTcpServer): TFMMonitor;
begin
  Result := TFMMonitor.Create(pvParent.Owner);
  Result.Parent := pvParent;
  Result.Align := alClient;
  Result.IocpTcpServer := pvIOCPTcpServer;
  Result.tmrReader.Enabled := True;
  Result.refreshState;   
end;

procedure TFMMonitor.lblRecvDblClick(Sender: TObject);
begin
  FIocpTcpServer.DataMoniter.clear;
end;

procedure TFMMonitor.lblWorkerCountClick(Sender: TObject);
begin
  if IocpTcpServer <> nil then
  begin
    ShowMessage(IocpTcpServer.IocpEngine.getStateINfo);
  end;
end;

procedure TFMMonitor.tmrReaderTimer(Sender: TObject);
begin
  refreshState;
end;

procedure TFMMonitor.refreshState;
begin
  if FIocpTcpServer = nil then
  begin
    lblsvrState.Caption := 'iocp server is null';
    exit;
  end;

  if FIocpTcpServer.DataMoniter = nil then
  begin
    lblsvrState.Caption := 'monitor is null';
    exit;
  end;

  if FIocpTcpServer.Active then
  begin
    lblsvrState.Caption := 'running';
  end else
  begin
    lblsvrState.Caption := 'stop';
  end;


  lblPostRecvINfo.Caption :=   Format('post:%d, response:%d, remain:%d',
     [
       FIocpTcpServer.DataMoniter.PostWSARecvCounter,
       FIocpTcpServer.DataMoniter.ResponseWSARecvCounter,
       FIocpTcpServer.DataMoniter.PostWSARecvCounter -
       FIocpTcpServer.DataMoniter.ResponseWSARecvCounter
     ]
    );

  lblRecvdSize.Caption := TRunTimeINfoTools.transByteSize(FIocpTcpServer.DataMoniter.RecvSize);


//  Format('post:%d, response:%d, recvd:%d',
//     [
//       FIocpTcpServer.DataMoniter.PostWSARecvCounter,
//       FIocpTcpServer.DataMoniter.ResponseWSARecvCounter,
//       FIocpTcpServer.DataMoniter.RecvSize
//     ]
//    );

  lblSend.Caption := Format('post:%d, response:%d, remain:%d',
     [
       FIocpTcpServer.DataMoniter.PostWSASendCounter,
       FIocpTcpServer.DataMoniter.ResponseWSASendCounter,
       FIocpTcpServer.DataMoniter.PostWSASendCounter - FIocpTcpServer.DataMoniter.ResponseWSASendCounter
     ]
    );

  lblSendRequest.Caption := Format('create:%d, out:%d, return:%d',
     [
       FIocpTcpServer.DataMoniter.SendRequestCreateCounter,
       FIocpTcpServer.DataMoniter.SendRequestOutCounter,
       FIocpTcpServer.DataMoniter.SendRequestReturnCounter
     ]
    );

  lblSendQueue.Caption := Format('push/pop/complted/abort:%d, %d, %d, %d',
     [
       FIocpTcpServer.DataMoniter.PushSendQueueCounter,
       FIocpTcpServer.DataMoniter.PostSendObjectCounter,
       FIocpTcpServer.DataMoniter.ResponseSendObjectCounter,
       FIocpTcpServer.DataMoniter.SendRequestAbortCounter
     ]
    );
  lblSentSize.Caption := TRunTimeINfoTools.transByteSize(FIocpTcpServer.DataMoniter.SentSize);


  lblAcceptEx.Caption := Format('post:%d, response:%d',
     [
       FIocpTcpServer.DataMoniter.PostWSAAcceptExCounter,
       FIocpTcpServer.DataMoniter.ResponseWSAAcceptExCounter
     ]
    );

  lblSocketHandle.Caption := Format('create:%d, destroy:%d',
     [
       FIocpTcpServer.DataMoniter.HandleCreateCounter,
       FIocpTcpServer.DataMoniter.HandleDestroyCounter
     ]
    );

  lblContextInfo.Caption := Format('create:%d, out:%d, return:%d',
     [
       FIocpTcpServer.DataMoniter.ContextCreateCounter,
       FIocpTcpServer.DataMoniter.ContextOutCounter,
       FIocpTcpServer.DataMoniter.ContextReturnCounter


     ]
    );

  lblOnlineCounter.Caption := Format('%d', [FIocpTcpServer.ClientCount]);
  
  lblWorkerCount.Caption := Format('%d', [FIocpTcpServer.WorkerCount]);


  lblRunTimeINfo.Caption :=TRunTimeINfoTools.getRunTimeINfo;


end;

end.
