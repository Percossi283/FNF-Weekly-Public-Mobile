var ring:FlxSprite;
var dadPos:Array<Float> = [];
var ringPos:Array<Float> = [];

function onLoad(){
    var list = ['BG', 'Ass1', 'Ass2', 'Ring1'];
    for(l in 0...list.length){
        var s = new FlxSprite().loadGraphic(Paths.image("shaggy/" + list[l]));
        s.scale.set(2.5,2.5);
        if(list[l] == 'Ring1') s.scale.set(3,3); s.x += 200;
        s.updateHitbox();
        s.screenCenter();
        if(list[l] == 'Ass2') s.x -= 100;
        s.antialiasing = true;
        if(list[l] != 'Ring1') s.scrollFactor.set(0.2 + (l * 0.2), 0.2 + (l * 0.2));
        add(s);    
    }

    ring = new FlxSprite().loadGraphic(Paths.image("shaggy/Ring2"));
    ring.scale.set(3,3);
    ring.updateHitbox();
    ring.screenCenter();
    ring.antialiasing = true;
    ring.x -= 200;
    add(ring);

}

function onCreatePost(){
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "empty";
    GameOverSubstate.loopSoundName = "empty";
    
    dadPos = [game.dad.x, game.dad.y];
    ringPos = [ring.x, ring.y + 100];

    game.snapCamFollowToPos(500, 200);
}

var speed:Float = 0.1;
var intensity:Float = 100;
var e:Float = 0;
trace(speed);
function onUpdate(elapsed){
    e += 0.1;
    game.dad.x = dadPos[0] + Math.cos(e * speed) * intensity;
    ring.x = ringPos[0] + Math.cos(e * speed) * intensity;
    game.dad.y = dadPos[1] + Math.sin(e * speed) * intensity;
    ring.y = ringPos[1] + Math.sin(e * speed) * intensity;
    // trace(game.dad.y);
}

function onGameOverStart() 
{
    var vgvideo = new PsychVideoSprite();
    vgvideo.addCallback('onFormat',()->{
        vgvideo.setGraphicSize(0,FlxG.height);
        vgvideo.updateHitbox();
        vgvideo.screenCenter();
        vgvideo.antialiasing = true;
        vgvideo.cameras = [game.camOther];
    });
    vgvideo.addCallback('onEnd',()->{
        FlxG.resetState();
    });
    vgvideo.load(Paths.video("shaggy"));
    vgvideo.play();
    GameOverSubstate.instance.add(vgvideo);
    GameOverSubstate.instance.boyfriend.alpha = 0;
}