# This file is part of the TaylorSeries.jl Julia package, MIT license
#
# Luis Benet & David P. Sanders
# UNAM
#
# MIT Expat license
#


# Functions
for T in (:Taylor1, :TaylorN)
    @eval begin
        function exp(a::$T)
            order = a.order
            aux = exp(constant_term(a))
            aa = one(aux) * a
            c = $T( aux, order )
            for k in eachindex(a)
                exp!(c, aa, k)
            end
            return c
        end

        function expm1(a::$T)
            order = a.order
            aux = expm1(constant_term(a))
            aa = one(aux) * a
            c = $T( aux, order )
            for k in eachindex(a)
                expm1!(c, aa, k)
            end
            return c
        end

        function log(a::$T)
            iszero(constant_term(a)) && throw(DomainError(a,
                """The 0-th order coefficient must be non-zero in order to expand `log` around 0."""))

            order = a.order
            aux = log(constant_term(a))
            aa = one(aux) * a
            c = $T( aux, order )
            for k in eachindex(a)
                log!(c, aa, k)
            end
            return c
        end
        function log1p(a::$T)
            # constant_term(a) < -one(constant_term(a)) && throw(DomainError(a,
            #         """The 0-th order coefficient must be larger than -1 in order to expand `log1`."""))

            order = a.order
            aux = log1p(constant_term(a))
            aa = one(aux) * a
            c = $T( aux, order )
            for k in eachindex(a)
                log1p!(c, aa, k)
            end
            return c
        end

        sin(a::$T) = sincos(a)[1]
        cos(a::$T) = sincos(a)[2]
        function sincos(a::$T)
            order = a.order
            aux = sin(constant_term(a))
            aa = one(aux) * a
            s = $T( aux, order )
            c = $T( cos(constant_term(a)), order )
            for k in eachindex(a)
                sincos!(s, c, aa, k)
            end
            return s, c
        end

        sinpi(a::$T) = sincospi(a)[1]
        cospi(a::$T) = sincospi(a)[2]
        function sincospi(a::$T)
            order = a.order
            aux = sinpi(constant_term(a))
            aa = one(aux) * a
            s = $T( aux, order )
            c = $T( cospi(constant_term(a)), order )
            for k in eachindex(a)
                sincospi!(s, c, aa, k)
            end
            return s, c
        end

        function tan(a::$T)
            order = a.order
            aux = tan(constant_term(a))
            aa = one(aux) * a
            c = $T(aux, order)
            c2 = $T(aux^2, order)
            for k in eachindex(a)
                tan!(c, aa, c2, k)
            end
            return c
        end

        function asin(a::$T)
            a0 = constant_term(a)
            a0^2 == one(a0) && throw(DomainError(a,
                """Series expansion of asin(x) diverges at x = ±1."""))

            order = a.order
            aux = asin(a0)
            aa = one(aux) * a
            c = $T( aux, order )
            r = $T( sqrt(1 - a0^2), order )
            for k in eachindex(a)
                asin!(c, aa, r, k)
            end
            return c
        end

        function acos(a::$T)
            a0 = constant_term(a)
            a0^2 == one(a0) && throw(DomainError(a,
                """Series expansion of asin(x) diverges at x = ±1."""))

            order = a.order
            aux = acos(a0)
            aa = one(aux) * a
            c = $T( aux, order )
            r = $T( sqrt(1 - a0^2), order )
            for k in eachindex(a)
                acos!(c, aa, r, k)
            end
            return c
        end

        function atan(a::$T)
            order = a.order
            a0 = constant_term(a)
            aux = atan(a0)
            aa = one(aux) * a
            c = $T( aux, order)
            r = $T(one(aux) + a0^2, order)
            iszero(constant_term(r)) && throw(DomainError(a,
                """Series expansion of atan(x) diverges at x = ±im."""))

            for k in eachindex(a)
                atan!(c, aa, r, k)
            end
            return c
        end

        function atan(a::$T, b::$T)
            c = atan(a/b)
            c[0] = atan(constant_term(a), constant_term(b))
            return c
        end

        sinh(a::$T) = sinhcosh(a)[1]
        cosh(a::$T) = sinhcosh(a)[2]
        function sinhcosh(a::$T)
            order = a.order
            aux = sinh(constant_term(a))
            aa = one(aux) * a
            s = $T( aux, order)
            c = $T( cosh(constant_term(a)), order)
            for k in eachindex(a)
                sinhcosh!(s, c, aa, k)
            end
            return s, c
        end

        function tanh(a::$T)
            order = a.order
            aux = tanh( constant_term(a) )
            aa = one(aux) * a
            c = $T( aux, order)
            c2 = $T( aux^2, order)
            for k in eachindex(a)
                tanh!(c, aa, c2, k)
            end
            return c
        end


        function asinh(a::$T)
            order = a.order
            a0 = constant_term(a)
            aux = asinh(a0)
            aa = one(aux) * a
            c = $T( aux, order )
            r = $T( sqrt(a0^2 + 1), order )
            iszero(constant_term(r)) && throw(DomainError(a,
                """Series expansion of asinh(x) diverges at x = ±im."""))
            for k in eachindex(a)
                asinh!(c, aa, r, k)
            end
            return c
        end

        function acosh(a::$T)
            a0 = constant_term(a)
            a0^2 == one(a0) && throw(DomainError(a,
                """Series expansion of acosh(x) diverges at x = ±1."""))

            order = a.order
            aux = acosh(a0)
            aa = one(aux) * a
            c = $T( aux, order )
            r = $T( sqrt(a0^2 - 1), order )
            for k in eachindex(a)
                acosh!(c, aa, r, k)
            end
            return c
        end

        function atanh(a::$T)
            order = a.order
            a0 = constant_term(a)
            aux = atanh(a0)
            aa = one(aux) * a
            c = $T( aux, order)
            r = $T(one(aux) - a0^2, order)
            iszero(constant_term(r)) && throw(DomainError(a,
                """Series expansion of atanh(x) diverges at x = ±1."""))

            for k in eachindex(a)
                atanh!(c, aa, r, k)
            end
            return c
        end



    end
end


# Recursive functions (homogeneous coefficients)
for T in (:Taylor1, :TaylorN)
    @eval begin
        @inline function identity!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            @inbounds c[k] = identity(a[k])
            return nothing
        end

        @inline function zero!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            @inbounds c[k] = zero(a[k])
            return nothing
        end

        @inline function one!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            zero!(c, a, k)
            if k == 0
                @inbounds c[0] = one(a[0])
            end
            return nothing
        end

        @inline function abs!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            z = zero(constant_term(a))
            if constant_term(constant_term(a)) > constant_term(z)
                return add!(c, a, k)
            elseif constant_term(constant_term(a)) < constant_term(z)
                return subst!(c, a, k)
            else
                throw(DomainError(a,
                    """The 0th order coefficient must be non-zero
                    (abs(x) is not differentiable at x=0)."""))
            end
            return nothing
        end

        @inline abs2!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number} = sqr!(c, a, k)

        @inline function exp!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                @inbounds c[0] = exp(constant_term(a))
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = k * a[k] * c[0]
            else
                @inbounds mul!(c[k], k * a[k], c[0])
            end
            @inbounds for i = 1:k-1
                if $T == Taylor1
                    c[k] += (k-i) * a[k-i] * c[i]
                else
                    mul!(c[k], (k-i) * a[k-i], c[i])
                end
            end
            @inbounds c[k] = c[k] / k
            return nothing
        end

        @inline function expm1!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                @inbounds c[0] = expm1(constant_term(a))
                return nothing
            end
            zero!(c, a, k)
            c0 = c[0]+one(c[0])
            if $T == Taylor1
                @inbounds c[k] = k * a[k] * c0
            else
                @inbounds mul!(c[k], k * a[k], c0)
            end
            @inbounds for i = 1:k-1
                if $T == Taylor1
                    c[k] += (k-i) * a[k-i] * c[i]
                else
                    mul!(c[k], (k-i) * a[k-i], c[i])
                end
            end
            @inbounds c[k] = c[k] / k
            return nothing
        end

        @inline function log!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                @inbounds c[0] = log(constant_term(a))
                return nothing
            elseif k == 1
                @inbounds c[1] = a[1] / constant_term(a)
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * a[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1)*a[1], c[k-1])
            end
            @inbounds for i = 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * a[i] * c[k-i]
                else
                    mul!(c[k], (k-i)*a[i], c[k-i])
                end
            end
            @inbounds c[k] = (a[k] - c[k]/k) / constant_term(a)
            return nothing
        end

        @inline function log1p!(c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = log1p(a0)
                return nothing
            elseif k == 1
                a0 = constant_term(a)
                a0p1 = a0+one(a0)
                @inbounds c[1] = a[1] / a0p1
                return nothing
            end
            a0 = constant_term(a)
            a0p1 = a0+one(a0)
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * a[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1)*a[1], c[k-1])
            end
            @inbounds for i = 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * a[i] * c[k-i]
                else
                    mul!(c[k], (k-i)*a[i], c[k-i])
                end
            end
            @inbounds c[k] = (a[k] - c[k]/k) / a0p1
            return nothing
        end

        @inline function sincos!(s::$T{T}, c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds s[0], c[0] = sincos( a0 )
                return nothing
            end
            x = a[1]
            zero!(s, a, k)
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds s[k] = x * c[k-1]
                @inbounds c[k] = -x * s[k-1]
            else
                mul!(s[k], x, c[k-1])
                mul!(c[k], -x, s[k-1])
            end
            @inbounds for i = 2:k
                x = i * a[i]
                if $T == Taylor1
                    s[k] += x * c[k-i]
                    c[k] -= x * s[k-i]
                else
                    mul!(s[k], x, c[k-i])
                    mul!(c[k], -x, s[k-i])
                end
            end

            @inbounds s[k] = s[k] / k
            @inbounds c[k] = c[k] / k
            return nothing
        end

        @inline function sincospi!(s::$T{T}, c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds s[0], c[0] = sincospi( a0 )
                return nothing
            end
            aa = $T(pi * a[0], a.order)
            @inbounds for ordQ in eachindex(a)
                aa[ordQ] = pi * a[ordQ]
            end
            sincos!(s, c, aa, k)
            return nothing
        end

        @inline function tan!(c::$T{T}, a::$T{T}, c2::$T{T}, k::Int) where {T<:Number}
            if k == 0
                @inbounds aux = tan( constant_term(a) )
                @inbounds c[0] = aux
                @inbounds c2[0] = aux^2
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = k * a[k] * c2[0]
            else
                @inbounds mul!(c[k], k * a[k], c2[0])
            end
            @inbounds for i = 1:k-1
                if $T == Taylor1
                    c[k] += (k-i) * a[k-i] * c2[i]
                else
                    mul!(c[k], (k-i) * a[k-i], c2[i])
                end
            end
            @inbounds c[k] = a[k] + c[k]/k
            sqr!(c2, c, k)

            return nothing
        end

        @inline function asin!(c::$T{T}, a::$T{T}, r::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = asin( a0 )
                @inbounds r[0] = sqrt( 1 - a0^2 )
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * r[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1) * r[1], c[k-1])
            end
            @inbounds for i in 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * r[i] * c[k-i]
                else
                    mul!(c[k], (k-i) * r[i], c[k-i])
                end
            end
            sqrt!(r, 1-a^2, k)
            @inbounds c[k] = (a[k] - c[k]/k) / constant_term(r)
            return nothing
        end

        @inline function acos!(c::$T{T}, a::$T{T}, r::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = acos( a0 )
                @inbounds r[0] = sqrt( 1 - a0^2 )
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * r[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1) * r[1], c[k-1])
            end
            @inbounds for i in 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * r[i] * c[k-i]
                else
                    mul!(c[k], (k-i) * r[i], c[k-i])
                end
            end
            sqrt!(r, 1-a^2, k)
            @inbounds c[k] = -(a[k] + c[k]/k) / constant_term(r)
            return nothing
        end

        @inline function atan!(c::$T{T}, a::$T{T}, r::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = atan( a0 )
                @inbounds r[0] = 1 + a0^2
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * r[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1) * r[1], c[k-1])
            end
            @inbounds for i in 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * r[i] * c[k-i]
                else
                    mul!(c[k], (k-i) * r[i], c[k-i])
                end
            end
            @inbounds sqr!(r, a, k)
            @inbounds c[k] = (a[k] - c[k]/k) / constant_term(r)
            return nothing
        end

        @inline function sinhcosh!(s::$T{T}, c::$T{T}, a::$T{T}, k::Int) where {T<:Number}
            if k == 0
                @inbounds s[0] = sinh( constant_term(a) )
                @inbounds c[0] = cosh( constant_term(a) )
                return nothing
            end
            x = a[1]
            zero!(s, a, k)
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds s[k] = x * c[k-1]
                @inbounds c[k] = x * s[k-1]
            else
                @inbounds mul!(s[k], x, c[k-1])
                @inbounds mul!(c[k], x, s[k-1])
            end
            @inbounds for i = 2:k
                x = i * a[i]
                if $T == Taylor1
                    s[k] += x * c[k-i]
                    c[k] += x * s[k-i]
                else
                    mul!(s[k], x, c[k-i])
                    mul!(c[k], x, s[k-i])
                end
            end
            s[k] = s[k] / k
            c[k] = c[k] / k
            return nothing
        end

        @inline function tanh!(c::$T{T}, a::$T{T}, c2::$T{T}, k::Int) where {T<:Number}
            if k == 0
                @inbounds aux = tanh( constant_term(a) )
                @inbounds c[0] = aux
                @inbounds c2[0] = aux^2
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = k * a[k] * c2[0]
            else
                @inbounds mul!(c[k], k * a[k], c2[0])
            end
            @inbounds for i = 1:k-1
                if $T == Taylor1
                    c[k] += (k-i) * a[k-i] * c2[i]
                else
                    mul!(c[k], (k-i) * a[k-i], c2[i])
                end
            end
            @inbounds c[k] = a[k] - c[k]/k
            sqr!(c2, c, k)

            return nothing
        end

        @inline function asinh!(c::$T{T}, a::$T{T}, r::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = asinh( a0 )
                @inbounds r[0] = sqrt( a0^2 + 1 )
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * r[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1) * r[1], c[k-1])
            end
            @inbounds for i in 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * r[i] * c[k-i]
                else
                    mul!(c[k], (k-i) * r[i], c[k-i])
                end
            end
            sqrt!(r, a^2+1, k)
            @inbounds c[k] = (a[k] - c[k]/k) / constant_term(r)
            return nothing
        end

        @inline function acosh!(c::$T{T}, a::$T{T}, r::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = acosh( a0 )
                @inbounds r[0] = sqrt( a0^2 - 1 )
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * r[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1) * r[1], c[k-1])
            end
            @inbounds for i in 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * r[i] * c[k-i]
                else
                    mul!(c[k], (k-i) * r[i], c[k-i])
                end
            end
            sqrt!(r, a^2-1, k)
            @inbounds c[k] = (a[k] - c[k]/k) / constant_term(r)
            return nothing
        end

        @inline function atanh!(c::$T{T}, a::$T{T}, r::$T{T}, k::Int) where {T<:Number}
            if k == 0
                a0 = constant_term(a)
                @inbounds c[0] = atanh( a0 )
                @inbounds r[0] = 1 - a0^2
                return nothing
            end
            zero!(c, a, k)
            if $T == Taylor1
                @inbounds c[k] = (k-1) * r[1] * c[k-1]
            else
                @inbounds mul!(c[k], (k-1) * r[1], c[k-1])
            end
            @inbounds for i in 2:k-1
                if $T == Taylor1
                    c[k] += (k-i) * r[i] * c[k-i]
                else
                    mul!(c[k], (k-i) * r[i], c[k-i])
                end
            end
            @inbounds sqr!(r, a, k)
            @inbounds c[k] = (a[k] + c[k]/k) / constant_term(r)
            return nothing
        end


    end
end


# Mutating functions for Taylor1{TaylorN{T}}
@inline function exp!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            # zero!(res[0], a[0], ordQ)
            exp!(res[0], a[0], ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[k][0][1]), a[0].order)
    zero!(res, a, k)
    for i = 0:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[i][ordQ]
            mul!(res[k], tmp, a[k-i], ordQ)
        end
    end
    div!(res, res, k, k)
    return nothing
end

@inline function expm1!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            # zero!(res[0], a[0], ordQ)
            expm1!(res[0], a[0], ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[k][0][1]), a[0].order)
    zero!(res, a, k)
    # i=0 term of sum
    @inbounds for ordQ in eachindex(a[0])
        one!(tmp, a[0], ordQ)
        add!(tmp, res[0], tmp, ordQ)
        tmp[ordQ] = k * tmp[ordQ]
        # zero!(res[k], a[0], ordQ)
        mul!(res[k], a[k], tmp, ordQ)
    end
    for i = 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[i][ordQ]
            mul!(res[k], tmp, a[k-i], ordQ)
        end
    end
    div!(res, res, k, k)
    return nothing
end

@inline function log!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            # zero!(res[k], a[0], ordQ)
            log!(res[k], a[0], ordQ)
        end
        return nothing
    elseif k == 1
        @inbounds for ordQ in eachindex(a[0])
            zero!(res[k], a[0], ordQ)
            div!(res[k], a[1], a[0], ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[k][0][1]), a[0].order)
    zero!(res, a, k)
    for i = 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, a[i], ordQ)
        end
    end
    div!(res, res, k, k)
    @inbounds for ordQ in eachindex(a[0])
        subst!(tmp, a[k], res[k], ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, a[0], ordQ)
    end
    return nothing
end

@inline function log1p!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            # zero!(res[k], a[0], ordQ)
            log1p!(res[k], a[0], ordQ)
        end
        return nothing
    end
    tmp1 = TaylorN( zero(a[k][0][1]), a[0].order)
    zero!(res, a, k)
    @inbounds for ordQ in eachindex(a[0])
        # zero!(res[k], a[0], ordQ)
        one!(tmp1, a[0], ordQ)
        add!(tmp1, tmp1, a[0], ordQ)
    end
    if k == 1
        @inbounds for ordQ in eachindex(a[0])
            div!(res[k], a[1], tmp1, ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[k][0][1]), a[0].order)
    for i = 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, a[i], ordQ)
        end
    end
    div!(res, res, k, k)
    @inbounds for ordQ in eachindex(a[0])
        subst!(tmp, a[k], res[k], ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, tmp1, ordQ)
    end
    return nothing
end

@inline function sincos!(s::Taylor1{TaylorN{T}}, c::Taylor1{TaylorN{T}},
        a::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            sincos!(s[0], c[0], a[0], ordQ)
        end
        return nothing
    end
    # The recursion formula
    x = TaylorN( a[1][0][1], a[0].order )
    zero!(s, a, k)
    zero!(c, a, k)
    @inbounds for i = 1:k
        for ordQ in eachindex(a[0])
            x[ordQ] = i * a[i][ordQ]
            mul!(s[k], x, c[k-i], ordQ)
            mul!(c[k], x, s[k-i], ordQ)
        end
    end
    div!(s, s, k, k)
    subst!(c, c, k)
    div!(c, c, k, k)
    return nothing
end

@inline function sincospi!(s::Taylor1{TaylorN{T}}, c::Taylor1{TaylorN{T}},
        a::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            sincospi!(s[0], c[0], a[0], ordQ)
        end
        return nothing
    end
    # aa = pi * a
    aa = Taylor1(zero(a[0]), a.order)
    @inbounds for ordT in eachindex(a)
        mul!(aa, pi, a, ordT)
    end
    sincos!(s, c, aa, k)
    return nothing
end

@inline function tan!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        res2::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds res[0] = tan( a[0] )
        # zero!(res2, res, 0)
        sqr!(res2, res, 0)
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order)
    zero!(res, a, k)
    for i = 0:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res2[i][ordQ]
            mul!(res[k], tmp, a[k-i], ordQ)
        end
    end
    @inbounds for ordQ in eachindex(a[0])
        # zero!(tmp, res[k], ordQ)
        tmp[ordQ] = res[k][ordQ] / k
        add!(res[k], a[k], tmp, ordQ)
    end
    # zero!(res2, res, k)
    sqr!(res2, res, k)
    return nothing
end

@inline function asin!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        r::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds res[0] = asin( a[0] )
        # r[0] = sqrt(1-a[0]^2)
        tmp = TaylorN( zero(a[0][0][1]), a[0].order)
        r[0] = square(a[0])
        for ordQ in eachindex(a[0])
            one!(tmp, a[0], ordQ)
            subst!(tmp, tmp, r[0], ordQ)
            # zero!(r[0], tmp, ordQ)
            sqrt!(r[0], tmp, ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order)
    zero!(res, a, k)
    for i in 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, r[i], ordQ)
        end
    end
    div!(res, res, k, k)
    @inbounds for ordQ in eachindex(a[0])
        subst!(tmp, a[k], res[k], ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, r[0], ordQ)
    end
    # Compute auxiliary term s=1-a^2
    s = Taylor1(zero(a[0]), a.order)
    for i = 0:k
        sqr!(s, a, i)
        subst!(s, s, i)
        if i == 0
            s[0] = one(s[0]) - s[0]
            add!(s, one(s), s, 0)
        end
    end
    # Update aux term r = sqrt(s) = sqrt(1-a^2)
    sqrt!(r, s, k)
    return nothing
end

@inline function acos!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        r::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds res[0] = acos( a[0] )
        # r[0] = sqrt(1-a[0]^2)
        tmp = TaylorN( zero(a[0][0][1]), a[0].order)
        r[0] = square(a[0])
        for ordQ in eachindex(a[0])
            one!(tmp, a[0], ordQ)
            subst!(tmp, tmp, r[0], ordQ)
            # zero!(r[0], tmp, ordQ)
            sqrt!(r[0], tmp, ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order)
    zero!(res, a, k)
    for i in 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, r[i], ordQ)
        end
    end
    div!(res, res, k, k)
    @inbounds for ordQ in eachindex(a[0])
        add!(tmp, a[k], res[k], ordQ)
        subst!(tmp, tmp, ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, r[0], ordQ)
    end
    # Compute auxiliary term s=1-a^2
    s = Taylor1(zero(a[0]), a.order)
    for i = 0:k
        sqr!(s, a, i)
        subst!(s, s, i)
        if i == 0
            s[0] = one(s[0]) - s[0]
            add!(s, one(s), s, 0)
        end
    end
    # Update aux term r = sqrt(s) = sqrt(1-a^2)
    sqrt!(r, s, k)
    return nothing
end

@inline function atan!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        r::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        res[0] = atan( a[0] )
        # zero!(r, a, 0)
        sqr!(r, a, 0)
        add!(r, r, one(a[0][0][1]), 0)
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order )
    zero!(res, a, k)
    for i in 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, r[i], ordQ)
        end
    end
    @inbounds for ordQ in eachindex(a[0])
        # zero!(tmp, res[k], ordQ)
        tmp[ordQ] = - res[k][ordQ] / k
        add!(tmp, a[k], tmp, ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, r[0], ordQ)
    end
    zero!(r, a, k)
    sqr!(r, a, k)
    return nothing
end

@inline function sinhcosh!(s::Taylor1{TaylorN{T}}, c::Taylor1{TaylorN{T}},
        a::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds for ordQ in eachindex(a[0])
            sinhcosh!(s[0], c[0], a[0], ordQ)
        end
        return nothing
    end
    # The recursion formula
    x = TaylorN( a[k][0][1], a[0].order )
    zero!(s, a, k)
    zero!(c, a, k)
    @inbounds for i = 1:k
        for ordQ in eachindex(a[0])
            x[ordQ] = i * a[i][ordQ]
            mul!(s[k], x, c[k-i], ordQ)
            mul!(c[k], x, s[k-i], ordQ)
        end
    end
    div!(s, s, k, k)
    div!(c, c, k, k)
    return nothing
end

@inline function tanh!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        res2::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds res[0] = tanh( a[0] )
        # zero!(res2, res, 0)
        sqr!(res2, res, 0)
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order)
    zero!(res, a, k)
    for i = 0:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res2[i][ordQ]
            mul!(res[k], tmp, a[k-i], ordQ)
        end
    end
    @inbounds for ordQ in eachindex(a[0])
        # zero!(tmp, res[k], ordQ)
        tmp[ordQ] = res[k][ordQ] / k
        subst!(res[k], a[k], tmp, ordQ)
    end
    zero!(res2, res, k)
    sqr!(res2, res, k)
    return nothing
end

@inline function asinh!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        r::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds res[0] = asinh( a[0] )
        # r[0] = sqrt(1+a[0]^2)
        tmp = TaylorN( zero(a[0][0][1]), a[0].order)
        r[0] = square(a[0])
        for ordQ in eachindex(a[0])
            one!(tmp, a[0], ordQ)
            add!(tmp, tmp, r[0], ordQ)
            # zero!(r[0], tmp, ordQ)
            sqrt!(r[0], tmp, ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order)
    zero!(res, a, k)
    for i in 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, r[i], ordQ)
        end
    end
    div!(res, res, k, k)
    @inbounds for ordQ in eachindex(a[0])
        subst!(tmp, a[k], res[k], ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, r[0], ordQ)
    end
    # Compute auxiliary term s=1+a^2
    s = Taylor1(zero(a[0]), a.order)
    for i = 0:k
        sqr!(s, a, i)
        if i == 0
            s[0] = one(s[0]) + s[0]
            add!(s, one(s), s, 0)
        end
    end
    # Update aux term r = sqrt(s) = sqrt(1+a^2)
    sqrt!(r, s, k)
    return nothing
end

@inline function acosh!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        r::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        @inbounds res[0] = acosh( a[0] )
        # r[0] = sqrt(a[0]^2-1)
        tmp = TaylorN( zero(a[0][0][1]), a[0].order)
        r[0] = square(a[0])
        for ordQ in eachindex(a[0])
            one!(tmp, a[0], ordQ)
            subst!(tmp, r[0], tmp, ordQ)
            # zero!(r[0], tmp, ordQ)
            sqrt!(r[0], tmp, ordQ)
        end
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order)
    zero!(res, a, k)
    for i in 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, r[i], ordQ)
        end
    end
    div!(res, res, k, k)
    @inbounds for ordQ in eachindex(a[0])
        subst!(tmp, a[k], res[k], ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, r[0], ordQ)
    end
    # Compute auxiliary term s=a^2-1
    s = Taylor1(zero(a[0]), a.order)
    for i = 0:k
        sqr!(s, a, i)
        if i == 0
            s[0] = one(s[0]) + s[0]
            subst!(s, s, one(s), 0)
        end
    end
    # Update aux term r = sqrt(s) = sqrt(a^2-1)
    sqrt!(r, s, k)
    return nothing
end

@inline function atanh!(res::Taylor1{TaylorN{T}}, a::Taylor1{TaylorN{T}},
        r::Taylor1{TaylorN{T}}, k::Int) where {T<:NumberNotSeries}
    if k == 0
        res[0] = atanh( a[0] )
        # zero!(r, a, 0)
        sqr!(r, a, 0)
        subst!(r, one(a[0][0][1]), r, 0)
        return nothing
    end
    # The recursion formula
    tmp = TaylorN( zero(a[0][0][1]), a[0].order )
    zero!(res, a, k)
    for i in 1:k-1
        @inbounds for ordQ in eachindex(a[0])
            tmp[ordQ] = (k-i) * res[k-i][ordQ]
            mul!(res[k], tmp, r[i], ordQ)
        end
    end
    @inbounds for ordQ in eachindex(a[0])
        # zero!(tmp, res[k], ordQ)
        tmp[ordQ] = res[k][ordQ] / k
        add!(tmp, a[k], tmp, ordQ)
        zero!(res[k], a[0], ordQ)
        div!(res[k], tmp, r[0], ordQ)
    end
    zero!(r, a, k)
    sqr!(r, a, k)
    return nothing
end




@doc doc"""
    inverse(f)

Return the Taylor expansion of ``f^{-1}(t)``, of order `N = f.order`,
for `f::Taylor1` polynomial if the first coefficient of `f` is zero.
Otherwise, a `DomainError` is thrown.

The algorithm implements Lagrange inversion at ``t=0`` if ``f(0)=0``:
```math
\begin{equation*}
f^{-1}(t) = \sum_{n=1}^{N} \frac{t^n}{n!} \left.
    \frac{{\rm d}^{n-1}}{{\rm d} z^{n-1}}\left(\frac{z}{f(z)}\right)^n
    \right\vert_{z=0}.
\end{equation*}
```

""" inverse

function inverse(f::Taylor1{T}) where {T<:Number}
    if f[0] != zero(T)
        throw(DomainError(f,
        """
        Evaluation of Taylor1 series at 0 is non-zero. For high accuracy, revert
        a Taylor1 series with first coefficient 0 and re-expand about f(0).
        """))
    end
    z = Taylor1(T,f.order)
    zdivf = z/f
    zdivfpown = zdivf
    S = TS.numtype(zdivf)
    coeffs = zeros(S,f.order+1)

    @inbounds for n in 1:f.order
        coeffs[n+1] = zdivfpown[n-1]/n
        zdivfpown *= zdivf
    end
    Taylor1(coeffs, f.order)
end


@doc doc"""
    inverse_map(f)

Return the Taylor expansion of ``f^{-1}(t)``, of order `N = f.order`,
for `f::Vector{TaylorN}`. The length of the vector `f` must be equal to the 
number of variables used in the Taylor polynomials, otherwise an `Error` is thrown.

This algorithm implements fixed point method for calculating the inverse mapping by 
splitting the map into linear and nonlinear parts. 
```

""" inverse_map

function inverse_map(f::Vector{TaylorN{T}}) where {T<:Number}
    if length(f) != get_numvars()
        throw(AssertionError(
            "Size of vector to invert must be equal to the number of variables."
        ))
    end

    # Split the polynomial mapping into linear and nonlinear parts
    linear = linear_polynomial.(f)
    nonlinear = nonlinear_polynomial.(f)

    # Get the inverse of the linear part matrix
    linear_inv = inv(TaylorSeries.jacobian(linear))

    linear_inv_nonlinear = linear_inv * nonlinear
    linear_inv_polynomial = linear_inv * get_variables()

    # Starting estimate of the inverse of the polynomial map
    map_inv = deepcopy(linear_inv_polynomial)

    # Fixed point iterations to obtain inverse mapping
    for _ in 1:(get_order() - 1)
        map_inv = [linear_inv_polynomial[i] - evaluate(linear_inv_nonlinear[i], map_inv) 
        for i in 1:length(f)]
    end

    return [evaluate(map_inv[i], get_variables() - constant_term.(f)) for i in 1:length(f)]
end



# Documentation for the recursion relations
@doc doc"""
    exp!(c, a, k) --> nothing

Update the `k-th` expansion coefficient `c[k+1]` of `c = exp(a)`
for both `c` and `a` either `Taylor1` or `TaylorN`.

The coefficients are given by

```math
\begin{equation*}
c_k = \frac{1}{k} \sum_{j=0}^{k-1} (k-j) a_{k-j} c_j.
\end{equation*}
```

""" exp!


@doc doc"""
    log!(c, a, k) --> nothing

Update the `k-th` expansion coefficient `c[k+1]` of `c = log(a)`
for both `c` and `a` either `Taylor1` or `TaylorN`.

The coefficients are given by

```math
\begin{equation*}
c_k = \frac{1}{a_0} \big(a_k - \frac{1}{k} \sum_{j=0}^{k-1} j a_{k-j} c_j \big).
\end{equation*}
```

""" log!


@doc doc"""
    sincos!(s, c, a, k) --> nothing

Update the `k-th` expansion coefficients `s[k+1]` and `c[k+1]`
of `s = sin(a)` and `c = cos(a)` simultaneously, for `s`, `c` and `a`
either `Taylor1` or `TaylorN`.

The coefficients are given by

```math
\begin{aligned}
s_k &=  \frac{1}{k}\sum_{j=0}^{k-1} (k-j) a_{k-j} c_j ,\\
c_k &= -\frac{1}{k}\sum_{j=0}^{k-1} (k-j) a_{k-j} s_j.
\end{aligned}
```

""" sincos!


@doc doc"""
    tan!(c, a, p, k::Int) --> nothing

Update the `k-th` expansion coefficients `c[k+1]` of `c = tan(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `p = c^2` and
is passed as an argument for efficiency.

The coefficients are given by

```math
\begin{equation*}
c_k = a_k + \frac{1}{k} \sum_{j=0}^{k-1} (k-j) a_{k-j} p_j.
\end{equation*}
```

""" tan!


@doc doc"""
    asin!(c, a, r, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = asin(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `r = sqrt(1-c^2)` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = \frac{1}{ \sqrt{r_0} }
    \big( a_k - \frac{1}{k} \sum_{j=1}^{k-1} j r_{k-j} c_j \big).
\end{equation*}
```

""" asin!


@doc doc"""
    acos!(c, a, r, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = acos(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `r = sqrt(1-c^2)` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = - \frac{1}{ r_0 }
    \big( a_k - \frac{1}{k} \sum_{j=1}^{k-1} j r_{k-j} c_j \big).
\end{equation*}
```

""" acos!


@doc doc"""
    atan!(c, a, r, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = atan(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `r = 1+a^2` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = \frac{1}{r_0}\big(a_k - \frac{1}{k} \sum_{j=1}^{k-1} j r_{k-j} c_j\big).
\end{equation*}
```

""" atan!


@doc doc"""
    sinhcosh!(s, c, a, k)

Update the `k-th` expansion coefficients `s[k+1]` and `c[k+1]`
of `s = sinh(a)` and `c = cosh(a)` simultaneously, for `s`, `c` and `a`
either `Taylor1` or `TaylorN`.

The coefficients are given by

```math
\begin{aligned}
s_k = \frac{1}{k} \sum_{j=0}^{k-1} (k-j) a_{k-j} c_j, \\
c_k = \frac{1}{k} \sum_{j=0}^{k-1} (k-j) a_{k-j} s_j.
\end{aligned}
```

""" sinhcosh!


@doc doc"""
    tanh!(c, a, p, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = tanh(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `p = a^2` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = a_k - \frac{1}{k} \sum_{j=0}^{k-1} (k-j) a_{k-j} p_j.
\end{equation*}
```

""" tanh!



@doc doc"""
    asinh!(c, a, r, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = asinh(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `r = sqrt(1-c^2)` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = \frac{1}{ \sqrt{r_0} }
    \big( a_k - \frac{1}{k} \sum_{j=1}^{k-1} j r_{k-j} c_j \big).
\end{equation*}
```

""" asinh!


@doc doc"""
    acosh!(c, a, r, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = acosh(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `r = sqrt(c^2-1)` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = \frac{1}{ r_0 }
    \big( a_k - \frac{1}{k} \sum_{j=1}^{k-1} j r_{k-j} c_j \big).
\end{equation*}
```

""" acosh!


@doc doc"""
    atanh!(c, a, r, k)

Update the `k-th` expansion coefficients `c[k+1]` of `c = atanh(a)`,
for `c` and `a` either `Taylor1` or `TaylorN`; `r = 1-a^2` and
is passed as an argument for efficiency.

```math
\begin{equation*}
c_k = \frac{1}{r_0}\big(a_k + \frac{1}{k} \sum_{j=1}^{k-1} j r_{k-j} c_j\big).
\end{equation*}
```

""" atanh!
