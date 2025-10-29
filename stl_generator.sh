#!/bin/bash


SRC="Flyhigh.scad"

OUTDIR="stl_output"
mkdir -p "$OUTDIR"


SIDE_PARTS=(
  Aileron_part
  Root_part
  Mid_part
  Tip_part
  Motor_arm_front
  Motor_arm_back
)


CENTER_PARTS=(
  Center_part
  Center_part_locker
)


SIDES=("Left" "Right")

echo "Generating STL in '$OUTDIR'..."
echo


for side in "${SIDES[@]}"; do
  for part in "${SIDE_PARTS[@]}"; do
    OUT="${OUTDIR}/${side}_${part}.stl"
    echo "Rendering (Manifold) → $OUT"

    openscad-nightly --backend=manifold --render -o "$OUT" -D "
      Left_side=$([ "$side" == "Left" ] && echo true || echo false);
      Right_side=$([ "$side" == "Right" ] && echo true || echo false);
      Aileron_part=false; Root_part=false; Mid_part=false; Tip_part=false;
      Mid_Tip_part=false; Motor_arm_full=false; Motor_arm_front=false;
      Motor_arm_back=false; Center_part=false; Center_part_locker=false;
      ${part}=true;
    " "$SRC"
  done
done


for part in "${CENTER_PARTS[@]}"; do
  OUT="${OUTDIR}/${part}.stl"
  echo "Rendering (Manifold, center) → $OUT"

  openscad-nightly --backend=manifold --render -o "$OUT" -D "
    Left_side=false;
    Right_side=false;
    Aileron_part=false; Root_part=false; Mid_part=false; Tip_part=false;
    Mid_Tip_part=false; Motor_arm_full=false; Motor_arm_front=false;
    Motor_arm_back=false; Center_part=false; Center_part_locker=false;
    ${part}=true;
  " "$SRC"
done

echo
echo "STL Generated in '$OUTDIR/'"
