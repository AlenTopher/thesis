{ Main view, where most of the application logic takes place.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameViewMain;

interface

uses Classes, Math,
  CastleVectors, CastleComponentSerialize, CastleWindow, CastleUtils,
  CastleUIControls, CastleControls, CastleKeysMouse, CastleCameras,
  CastleViewport, CastleScene, CastleSceneCore, CastleTransform, CastleSoundEngine, X3DNodes;

type
  { Main view, where most of the application logic takes place. }
  TViewMain = class(TCastleView)
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    LabelFps: TCastleLabel;
    Viewport1: TCastleViewport;
    Camera1: TCastleCamera;
    PointLight1: TCastlePointLight;
    Ground: TCastleScene;
    Player: TCastleScene;
    Enemy: TCastleScene;
    Tiles: TCastleTransformReference;
    BoxCollider4: TCastleBoxCollider;
    RigidBody4: TCastleRigidBody;
    BoxCollider3: TCastleBoxCollider;
    RigidBody3: TCastleRigidBody;
    WalkNavigation1: TCastleWalkNavigation;
    Wall: TCastleTransformReference;
    Brick: TCastleScene;
    Weapon1: TCastleScene;
    Weapon2: TCastleScene;
    Weapon3: TCastleScene;
    Weapon4: TCastleScene;

  strict private
         PlaneTransforms: array [0 .. 50, 0 .. 50] of TCastleTransformReference;
         WallTransforms: array[0 .. 50, 0 ..50] of TCastleTransformReference;
         Gound1: TCastleTransformReference;
         {check for collision}
         IsCollision:Boolean;
         PlayerHitWall: Boolean;
         {Player restrictions}

         PlayerCanJump: Boolean;
         PlayerCanHit: Boolean;
         LevelComplete: Boolean;

         {Enemy Restrictions}
         EnemyCanMove2: Boolean;
         EnemyCanJump: Boolean;


         {Has Weapon}
         HasWP0: Boolean;
         HasWP1: Boolean;
         HasWP2: Boolean;
         HasWP3: Boolean;
         HasWP4: Boolean;

  public
    EnemyHitPoints: Integer;
    PlayerHitPoints: Integer;
    MyInt: Integer;
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: Single; var HandleInput: Boolean); override;
    procedure Assign(Source: TPersistent); override;

    function Press(const Event: TInputPressRelease): Boolean; override;
  end;

var
  ViewMain: TViewMain;

implementation

uses SysUtils;

{ TViewMain ----------------------------------------------------------------- }

constructor TViewMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmain.castle-user-interface';
end;

procedure TViewMain.Start;
var
  T:TVector3;
  I, J, Wea:Integer;
begin
  Randomize;
  inherited;
    // RigidBody4.Exists:= True;
  {Gound1 := Tiles.Create(FreeAtStop);
  Gound1.Translation := Vector3(-5,0,0);
  Viewport1.Items.Add(Tiles);  }
   //T := Plane1.Translation;
   // T := T + Vector3(0,0,10);
   {Collision Check}
   IsCollision := Player.WorldBoundingBox.Collides(Wall.WorldBoundingBox);
   if (IsCollision = True) then
      begin
      Player.Translation := Player.Translation + Vector3(7,0,7);
      end;

   {Weapon Generation}
           for i:=0 to 4 do
           begin
           Wea := random(4);
           case (Wea) of
                0: PlayerCanHit:=false;
                1: PlayerCanHit:=true;
                2: PlayerCanHit:=true;
                2: PlayerCanJump:=true;
                3: PlayerCanHit:=true;
                4: PlayerCanHit:=true;
                end;

           end;

   {Map Generation}
  I := Low(PlaneTransforms);
   While I < High(PlaneTransforms) do begin
         J := Low(PlaneTransforms[I]);
   While J < High(PlaneTransforms[I]) do  begin
        PlaneTransforms[I,J] := TCastleTransformReference.Create(Application);
        PlaneTransforms[I,J].Translation := Vector3(I, 0, J);
        PlaneTransforms[I,J].add(Tiles);
        Viewport1.Items.Add(PlaneTransforms[I,J]);
        J += 7;
        end;
   I += 7;
   end;

   I := Low(WallTransforms);
   While I < High(WallTransforms) do begin
         J := Low(WallTransforms[I]);
   While J < High(WallTransforms[I]) do begin
           WallTransforms[I,J] := TCastleTransformReference.Create(Application);
     //      if abs(dopower((I-26),2) + dopower((J-26),2) - dopower(26,2)) < dopower(2.2,2) then
           if abs(((I-26)**2) + ((J-26)**2) - (26**2)) < (4.8**2) then
              WallTransforms[I,J].Translation := Vector3(I,0,J);
              WallTransforms[I,J].add(Wall);
              Viewport1.Items.Add(WallTransforms[I,J]);
              J += 7;
   end;
      I += 7;
   end;

   //Player.Translation := Vector3(0,0,0);
 // Plane1.Translation := T;
end;

procedure TViewMain.Update(const SecondsPassed: Single; var HandleInput: Boolean);
  //const
   // MoveSpeed = 7;
begin
  inherited;
  { This virtual method is executed every frame (many times per second). }
  Assert(LabelFps <> nil, 'If you remove LabelFps from the design, remember to remove also the assignment "LabelFps.Caption := ..." from code');
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;
  //IsCollision := Player.WorldBoundingBox.Collides(Tiles.WorldBoundingBox);
end;
procedure TViewMain.Assign(Source: TPersistent);
begin
  end;

function TViewMain.Press(const Event: TInputPressRelease): Boolean;
begin
  IsCollision := Player.WorldBoundingBox.Collides(Enemy.WorldBoundingBox);
  Result := inherited;
  if Result then Exit; // allow the ancestor to handle keys

  { This virtual method is executed when user presses
    a key, a mouse button, or touches a touch-screen.

    Note that each UI control has also events like OnPress and OnClick.
    These events can be used to handle the "press", if it should do something
    specific when used in that UI control.
    The TViewMain.Press method should be used to handle keys
    not handled in children controls.
  }

  // Use this to handle keys:
  {
  if Event.IsKey(keyXxx) then
  begin
    // DoSomething;
    Exit(true); // key was handled
  end;
  }
  if Event.IsMouseButton(buttonRight) then
  begin
    // WalkNavigation1.MouseLook := not WalkNavigation1.MouseLook;
    end;
  if Event.IsKey(keyArrowLeft) then
  begin
    Player.Translation := Player.Translation + Vector3(-7,0,0);
    Camera1.Translation := Camera1.Translation + Vector3(-7,0,0);
    if (IsCollision = True) then
       begin
         If (PlayerCanHit = True)then
            begin
               EnemyHitPoints := EnemyHitPoints - 1;

       end;
    Exit(true);
  end;
  if Event.IsKey(keyArrowRight) then
  begin
    Player.Translation := Player.Translation + Vector3(7,0,0);
    Camera1.Translation := Camera1.Translation + Vector3(7,0,0);
    if (IsCollision = True) then
       begin
       Player.Translation := Player.Translation - Vector3(7,0,0);
       Camera1.Translation := Camera1.Translation - Vector3(7,0,0);

       end;
    Exit(true);
  end;
  if Event.IsKey(keyArrowUp) then
  begin
    Player.Translation := Player.Translation + Vector3(0,0,-7);
    Camera1.Translation := Camera1.Translation + Vector3(0,0,-7);
    if (IsCollision = True) then
       begin
       Player.Translation := Player.Translation - Vector3(0,0,-7);
       Camera1.Translation := Camera1.Translation - Vector3(0,0,-7);
       end;
    Exit(true);
  end;
  if Event.IsKey(keyArrowDown) then
  begin
    Player.Translation := Player.Translation + Vector3(0,0,7);
    Camera1.Translation := Camera1.Translation + Vector3(0,0,7);
    if (IsCollision = True) then
       begin
       Player.Translation := Player.Translation - Vector3(0,0,7);
       Camera1.Translation := Camera1.Translation - Vector3(0,0,7);

       end;
    Exit(true);
  end;
  if
  end;
end;

end.
