function ff = binarySearch(f, d_min,bx,bz,r,x,z,n)
    % f: Ŀ�꺯��
    % d: ��ֵ
    % ��ʼ������
    lo = 0;
    hi = 1e4;
    % �������Χ
    tolerance = 1e-3;

    % ���ֲ���
    while lo < hi
        mid = (lo + hi) / 2;
        if f(mid,bx,bz,r,x,z,n) >= d_min
            % ��� f(mid) ����������������벿��
            hi = mid;
        else
            % ���������Ұ벿��
            lo = mid;
        end

        % ����Ƿ�ﵽ���㹻�ľ���
        if abs(hi - lo) < tolerance
            break;
        end
    end

    ff = lo;
end