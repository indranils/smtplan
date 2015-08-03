
function [] = generateZ3File (initpos, goalpos, number_of_hops)
    
    default_min = -1000;
    default_max = 1000;

    % Workspace dimensions
    width = 30;
    height = 30;
    
    wksp = createWorkspace(width,height);
    %wksp = [];
    
    fid = fopen ('constraints.smt2', 'w');
  
    
    for k = 1 : size(wksp,1)
        fprintf(fid, ';;Obstacle %d\n', k);
        fprintf(fid, '(declare-fun obs%dxbl () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dxbr () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dxtr () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dxtl () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dybl () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dybr () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dytr () Real)\n', k);
        fprintf(fid, '(declare-fun obs%dytl () Real)\n\n', k);
    end
    
    fprintf(fid, '(declare-fun epsilon () Real)\n\n');
    
    
    for k = 0 : number_of_hops
        fprintf(fid, '(declare-fun x%d () Real)\n', k);
        fprintf(fid, '(declare-fun y%d () Real)\n', k);
    end
    
    fprintf(fid, '\n');

    for k = 1 : size(wksp,1)
        for m = 1 : number_of_hops
            fprintf(fid, '(declare-fun a%d_%d () Real)\n', k, m);
            fprintf(fid, '(declare-fun b%d_%d () Real)\n', k, m);
            fprintf(fid, '(declare-fun c%d_%d () Real)\n', k, m);
        end
    end
    
    fprintf(fid, '\n\n');

    for k = 1 : size(wksp,1)
        fprintf(fid, ';;Obstacle %d\n', k);
        fprintf(fid, '(assert (= obs%dxbl %f))\n', k, wksp{k,1}(1,1));
        fprintf(fid, '(assert (= obs%dxbr %f))\n', k, wksp{k,1}(1,2));
        fprintf(fid, '(assert (= obs%dxtr %f))\n', k, wksp{k,1}(1,2));
        fprintf(fid, '(assert (= obs%dxtl %f))\n', k, wksp{k,1}(1,1));
        fprintf(fid, '(assert (= obs%dybl %f))\n', k, wksp{k,1}(2,1));
        fprintf(fid, '(assert (= obs%dybr %f))\n', k, wksp{k,1}(2,1));
        fprintf(fid, '(assert (= obs%dytr %f))\n', k, wksp{k,1}(2,2));
        fprintf(fid, '(assert (= obs%dytl %f))\n\n', k, wksp{k,1}(2,2));
    end
    
    fprintf(fid, '(assert (= epsilon 1))\n\n');
    
    for k = 0 : number_of_hops
        if (k == 0)
            fprintf(fid, '(assert (= x0 %d))\n', initpos(1));
            fprintf(fid, '(assert (= y0 %d))\n', initpos(2));
        end
        
        if (k > 0 && k < number_of_hops)
            fprintf(fid, '(assert (>= x%d 0))\n', k);
            fprintf(fid, '(assert (<= x%d 30))\n', k);
            fprintf(fid, '(assert (>= y%d 0))\n', k);
            fprintf(fid, '(assert (<= y%d 30))\n', k);
        end
         
        if (k == number_of_hops)
            fprintf(fid, '(assert (>= x%d %d))\n', k, goalpos(1) - 1);
            fprintf(fid, '(assert (<= x%d %d))\n', k, goalpos(1) + 1);
            fprintf(fid, '(assert (>= y%d %d))\n', k, goalpos(2) - 1);
            fprintf(fid, '(assert (<= y%d %d))\n', k, goalpos(2) + 1);
        end
        
        fprintf(fid, '\n');
    end
        
    
    fprintf(fid, '\n\n');
    
    
    % Check if the obstacles are ouside the rectangle covering the envelop
    
    for k = 1 : size(wksp,1)
        for m = 1 : number_of_hops
            fprintf(fid, '(assert (or (and (< (+ (* a%d_%d x%d) (* b%d_%d y%d) c%d_%d (- epsilon)) 0)\n', k, m, m -1 , k, m, m - 1, k, m);
            fprintf(fid, '      (< (+ (* a%d_%d x%d) (* b%d_%d y%d) c%d_%d (- epsilon)) 0)\n', k, m, m, k, m, m, k, m);
            fprintf(fid, '      (> (+ (* a%d_%d obs%dxbl) (* b%d_%d obs%dybl) c%d_%d (- epsilon)) 0)\n', k, m, k, k, m, k, k, m);
            fprintf(fid, '      (> (+ (* a%d_%d obs%dxbr) (* b%d_%d obs%dybr) c%d_%d (- epsilon)) 0)\n', k, m, k, k, m, k, k, m);
            fprintf(fid, '      (> (+ (* a%d_%d obs%dxtl) (* b%d_%d obs%dytl) c%d_%d (- epsilon)) 0)\n', k, m, k, k, m, k, k, m);
            fprintf(fid, '      (> (+ (* a%d_%d obs%dxtr) (* b%d_%d obs%dytr) c%d_%d (- epsilon)) 0))\n', k, m, k, k, m, k, k, m);
            fprintf(fid, ' (and (> (+ (* a%d_%d x%d) (* b%d_%d y%d) c%d_%d (- epsilon)) 0)\n', k, m, m -1, k, m, m - 1, k, m);
            fprintf(fid, '      (> (+ (* a%d_%d x%d) (* b%d_%d y%d) c%d_%d (- epsilon)) 0)\n', k, m, m, k, m, m, k, m);
            fprintf(fid, '      (< (+ (* a%d_%d obs%dxbl) (* b%d_%d obs%dybl) c%d_%d (- epsilon)) 0)\n', k, m, k, k, m, k, k, m);
            fprintf(fid, '      (< (+ (* a%d_%d obs%dxbr) (* b%d_%d obs%dybr) c%d_%d (- epsilon)) 0)\n', k, m, k, k, m, k, k, m);
            fprintf(fid, '      (< (+ (* a%d_%d obs%dxtl) (* b%d_%d obs%dytl) c%d_%d (- epsilon)) 0)\n', k, m, k, k, m, k, k, m);
            fprintf(fid, '      (< (+ (* a%d_%d obs%dxtr) (* b%d_%d obs%dytr) c%d_%d (- epsilon)) 0))))\n\n', k, m, k, k, m, k, k, m);
        end
    end
    
    fprintf(fid, '(check-sat)\n');
    
    fprintf(fid, '\n\n');
    for k = 0 : number_of_hops
        fprintf(fid, '(get-value (x%d))\n', k);
        fprintf(fid, '(get-value (y%d))\n', k);
    end
    fclose(fid);
end