unit UMyStack;

interface
  uses crt, dos;
  type reper = ^element;
       element = record
         director, val_init: string;
         link: reper;
       end;
       procedure ExecCommand(Command: String);
       procedure DeleteFiles;
       procedure CopyFiles(DDir: string); { DestDir }
       procedure DeleteDirectory(Dir: string);
       procedure CopyDirectory(ExpDir, DestDir: string);

implementation
  procedure ExecCommand(Command: String);
    begin
      if Command <> '' then
        Command := '/C ' + Command;
      SwapVectors;
      Exec(GetEnv('COMSPEC'), Command);
      SwapVectors;
      if DosError <> 0 then
        Writeln('Could not execute COMMAND.COM');
    end;

  procedure DeleteFiles;
    var FileInfo: SearchRec;
        f: File;
        attr: word;
    begin
      FindFirst('*.*', Archive + ReadOnly + SysFile + Hidden, FileInfo);
      while DosError = 0 do begin
        assign(f, FileInfo.Name);
        SetFAttr(f, Archive);
        clrscr;
        ExecCommand('del' + ' ' + FileInfo.Name);
        FindNext(FileInfo);
      end;
    end;

  procedure CopyFiles(DDir: string);
    var FileInfo: SearchRec;
        f: File;
    begin
      FindFirst('*.*', Archive + ReadOnly + SysFile + Hidden, FileInfo);
      while DosError = 0 do begin
        clrscr;
        ExecCommand('copy' + ' ' + FileInfo.Name + ' ' + DDir);
        FindNext(FileInfo);
      end;
    end;

  procedure DeleteDirectory(Dir: string);
    var Stiva, p, vf: reper;
        D: SearchRec;
        j: integer;
    begin
      ChDir(Dir);
      j:=length(Dir);
      while (Dir[j] <> '\')and(j > 0) do
        dec(j);
      delete(Dir, 1, j);
      new(Stiva); new(vf);
      Stiva^.director:=''; Stiva^.val_init:='';
      vf^.director:=Dir; vf^.val_init:=''; vf^.link:=Stiva;
      repeat
        FindFirst('*', Directory, D);
        FindNext(D);
        while ((D.name <> vf^.val_init)and(DosError = 0)) do
          FindNext(D);
        if (DosError <> 0) then begin
          FindFirst('*', Directory, D);
          FindNext(D);
          FindNext(D);
        end
        else
          FindNext(D);
        if (DosError = 0) then begin
          {$I-}
          ChDir(D.name);
          {$I+}
          if (IOResult = 0) then begin
            new(p); p^.director:=D.name;
            p^.link:=vf; vf^.val_init:=D.name; vf:=p;
          end;
            vf^.val_init:=D.name
        end
        else begin
          DeleteFiles;
          ExecCommand('CD..');
          ExecCommand('RD' + ' ' + vf^.director);
          p:=vf; vf:=vf^.link; dispose(p);
        end;
      until (vf = Stiva);
      dispose(Stiva);
    end;

  procedure CopyDirectory(ExpDir, DestDir: string);
    var Stiva, p, vf: reper;
        D, D_aux: SearchRec;
        j: integer;
        D1: string;
    begin
      D1:=ExpDir;
      ChDir(D1);
      j:=length(D1);
      while (D1[j] <> '\')and(j > 0) do
        dec(j);
      delete(D1, 1, j);
      new(Stiva); new(vf);
      Stiva^.director:=''; Stiva^.val_init:='';
      vf^.director:=D1; vf^.val_init:=''; vf^.link:=Stiva;
      ChDir(DestDir); MkDir(vf^.director);
      if length(DestDir) > 3 then
        DestDir:=DestDir + '\' + vf^.director
      else
        DestDir:=DestDir + vf^.director;
      ChDir(ExpDir);
      repeat
        FindFirst('*', Directory, D);
        FindNext(D);
        while ((D.name <> vf^.val_init)and(DosError = 0)) do
          FindNext(D);
        if (DosError <> 0) then begin
          FindFirst('*', Directory, D);
          FindNext(D);
          FindNext(D);
        end
        else
          FindNext(D);
        if (DosError = 0) then begin
          {$I-}
          ChDir(D.name);
          {$I+}
          if (IOResult = 0) then begin
            new(p); p^.director:=D.name;
            p^.link:=vf; vf^.val_init:=D.name; vf:=p;
            ChDir(DestDir);
            FindFirst('*', Directory, D_aux);
            FindNext(D_aux);
            while ((D_aux.name <> p^.director)and(DosError = 0)) do
              FindNext(D_aux);
            if (DosError <> 0) then
              MkDir(vf^.director)
            else;
            DosError:=0;
            if length(DestDir) > 3 then
              DestDir:=DestDir + '\' + vf^.director
            else
              DestDir:=DestDir + '\' + vf^.director;

            if length(ExpDir) > 3 then
              ExpDir:=ExpDir + '\' + vf^.director
            else
              ExpDir:=ExpDir + vf^.director;
            ChDir(ExpDir); ChDir(ExpDir);
          end
          else
            vf^.val_init:=D.name;
        end
        else begin
          CopyFiles(DestDir);
          ExecCommand('CD..');
          j:=length(DestDir);
          while (DestDir[j] <> '\')and(j > 0) do
            dec(j);
          delete(DestDir, j, length(DestDir) - j + 1);
          j:=length(ExpDir);
          while (ExpDir[j] <> '\')and(j > 0) do
            dec(j);
          delete(ExpDir, j, length(ExpDir) - j + 1);
          p:=vf; vf:=vf^.link; dispose(p);
        end;
      until (vf = Stiva);
      dispose(Stiva);
    end;

end.