clear()
exec('q3d_utils.sci');

exec('q3d_polynomials.sci');
exec('q3d_sbb.sci');

exec('q3d_diff_flatness.sci');
exec('q3d_fdm.sci');
exec('q3d_display.sci');


t0 = 0;
t1 = 2.;
dt = 0.01;
time = t0:dt:t1;

if (0)
  // polynomials
  b0 = [0 0 0 0 0; 0 0 0 0 0];
  b1 = [5 0 0 0 0; 0 0 0 0 0];
  [coefs] = poly_get_coef_from_bound(time, b0, b1);
  [fo_traj] = poly_gen_traj(time, coefs);
else
// differential equation
  [fo_traj] = sbb_gen_traj(time, 5, rad_of_deg(30), [0 0] [20 0]);
end

diff_flat_cmd = zeros(2,length(time));
diff_flat_ref = zeros(FDM_SSIZE, length(time));
for i=1:length(time)
  diff_flat_cmd(:,i) = df_input_of_fo(fo_traj(:,:,i));
  diff_flat_ref(:,i) = df_state_of_fo(fo_traj(:,:,i));
end

fdm_init(time, df_state_of_fo(b0) ); 
for i=2:length(time)
  u1 = diff_flat_cmd(1,i-1);
  u2 = diff_flat_cmd(2,i-1);
  m1 = 0.5*(u1+u2);
  m2 = 0.5*(u1-u2);
  fdm_run(i, [m1 m2]')
end
  
set("current_figure",0);
clf();
f=get("current_figure");
f.figure_name="Flat Outputs Trajectory";
display_fo(time, fo_traj);

set("current_figure",1);
clf();
f=get("current_figure");
f.figure_name="Commands";
display_commands(time, diff_flat_cmd);

set("current_figure",2);
clf();
f=get("current_figure");
f.figure_name="Reference";
display_fo_ref(time, diff_flat_ref);

set("current_figure",3);
clf();
f=get("current_figure");
f.figure_name="FDM";
display_fdm();