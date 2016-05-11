use v6;

use Crypt::GCrypt :xs;

class Crypt::GCrypt::Digest is Crypt::GCrypt {

    use Crypt::GCrypt::Raw :ALL,:memcpy;
    use NativeCall;
    
    has gcry_md_hd_t $!h;
    has uint32 $.digest-length;

    our sub digest_algo_available(Str $name --> Bool) {
	? gcry_md_map_name($name.lc)
    }
    
    subset DigestName of Str where { gcry_md_map_name($_) }

    submethod BUILD(
	DigestName :$algorithm,
        Bool :$secure,
        :$hmac,
    ) {
        my gcry_uint $flags = 0;
        $flags +|= GCRY_MD_FLAG_SECURE if $secure;
        $flags +|= GCRY_MD_FLAG_HMAC with $hmac;
        my gcry_int $digest = gcry_md_map_name($algorithm);
        $!digest-length = gcry_md_get_algo_dlen($digest);

        my $h-buf = CArray[gcry_md_hd_t].new;
	$h-buf[0] = gcry_md_hd_t;
	self.err = gcry_md_open($h-buf, $digest, $flags);
	$!h = $h-buf[0];
        self.setkey($_) with $hmac;
    }

    multi method setkey(Str $key, Str :$enc = 'latin-1') {
	$.setkey( $key.encode($enc) );
    }
    multi method setkey($mykey is copy) {
	$.err = gcry_md_setkey($!h, xs-ptr($mykey), $mykey.elems);
    }

    multi method write(Str $stuff, Str :$enc = 'latin-1') {
	$.write( $stuff.encode($enc) );
    }
    multi method write( $stuff is copy ) {
	gcry_md_write($!h, xs-ptr($stuff), $stuff.elems);
    }

    method read() {
        my Pointer $out = gcry_md_read($!h, 0);
        my $buf = xs-newz( $!digest-length );
        memcpy( $buf+0, $out, $!digest-length );
        $buf;
    }

    multi method FALLBACK(DigestName $algorithm, $stuff, |c --> Buf) {
        my &meth = method ($_) {
            my $obj = self.new( :$algorithm, |c );
            $obj.write: $_;
            Buf.new: $obj.read;
        };
        self.WHAT.^add_method($algorithm, &meth );
        self."$algorithm"($stuff);
    }

}
